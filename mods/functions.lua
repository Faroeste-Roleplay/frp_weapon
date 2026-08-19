function createWeaponMod(entity, model, weaponBase, knife)
    local playerPed = entity or PlayerPedId()

    if not IsModelInCdimage(model) then
        return
    end

    RequestModel(model)

    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    GiveWeaponToPed(playerPed, weaponBase, 0, true, false)
    -- GiveWeaponToPed_2(playerPed, joaat(weaponBase), 0, true, false, 0, false, 0.5, 1.0, 0, false, 0.0, false)

    local weapon
    local timeout = GetGameTimer() + 1000

    while not weapon and GetGameTimer() < timeout do
        weapon = GetPedCurrentWeaponEntityIndex(playerPed)
        Citizen.Wait(0)
    end

    if not weapon then
        return
    end

    SetEntityAlpha(weapon, 0)

    Citizen.InvokeNative(0xA7A57E89E965D839, weapon, 1.0)
    Citizen.InvokeNative(0xA9EF4AD10BDDDB57, weapon, 1.0)
    Citizen.InvokeNative(0x812CE61DEBCAB948, weapon, 1.0)
    Citizen.InvokeNative(0xE22060121602493B, weapon, 1.0)

    local weaponEntity = spawnModel(model, GetEntityCoords(playerPed))

    SetEntityAsMissionEntity(weaponEntity, true, true)
    if knife then
        -- print(json.encode(knife))
        -- AttachEntityToEntity(weaponEntity, PlayerPedId(), GetEntityBoneIndexByName(PlayerPedId(), "PH_R_HandStrap_00"), 0.021, 0.038, -0.028, -156.685, -68.696, -57.938, true, true, false, false, 0, true)
        -- AttachEntityToEntity(weaponEntity, playerPed, GetEntityBoneIndexByName(playerPed, "PH_R_HandStrap_00"), 0.022, 0.038, -0.029, -136.167, -66.912, -68.565, true, true, false, false, 0, true)
        AttachEntityToEntity(weaponEntity, playerPed, GetEntityBoneIndexByName(playerPed, knife.bone), knife.x,knife.y,knife.z,knife.rx,knife.ry,knife.rz, false, false, false, false, 0, true, false, false)
    else
        AttachEntityToEntity(weaponEntity, weapon, 0, vector3(0, 0, 0), vector3(0, 0, 0), false, false, false, false, 0, true, false, false)
    end

    SetModelAsNoLongerNeeded(model)

    return weapon, weaponEntity
end

function spawnModel(model, position)
    RequestModel(model)

    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    local entity = CreateObject(model, position.x, position.y, position.z, false, false, true)

    SetEntityAsMissionEntity(entity, true, true)

    SetModelAsNoLongerNeeded(model)

    return entity
end


function removeWeaponFromPed(ped, weaponHash)
    RemoveWeaponFromPed(ped, weaponHash)
end

function getMetadataSlotId(metaData,slot)
    for k,v in pairs(metaData) do
        if v.slot == slot then
            return v.metadata
        end
    end

    return false
end

function GetPedCurrentWeaponEntityIndex(ped, p1)
    return Citizen.InvokeNative(0x3B390A939AF0B5FC, ped, p1)
end

function removeVariables()
    TriggerServerEvent("frp_weapon:removeWeaponInWorld", weaponsSystemMods.use,NetworkGetNetworkIdFromEntity(PlayerPedId()))

    DeleteEntity(weaponsSystemMods.entity)
    
    weaponsSystemMods.use          = nil
    weaponsSystemMods.entity       = nil
    weaponsSystemMods.entityWeapon = nil    
end