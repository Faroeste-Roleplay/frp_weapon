weaponsSystemMods  = {}
local distanceSync = 100.0

RegisterNetEvent("frp_weapon:giveWeaponMod")
AddEventHandler("frp_weapon:giveWeaponMod",function(data)
    local ped = PlayerPedId()

    if not weaponsSystemMods.use then
        weaponsSystemMods.use = data.client

        TriggerServerEvent("frp_weapon:addWeaponInWorld", weaponsSystemMods.use, NetworkGetNetworkIdFromEntity(PlayerPedId()))

        local weapon, weaponProp = createWeaponMod(ped, data.client.model, data.client.weapon, data.client.knife)
        
        weaponsSystemMods.entityWeapon = weapon
        weaponsSystemMods.entity       = weaponProp
        
        if data.client.knife then
            local ped       = PlayerPedId()
            local knife     = data.client.knife
            local boneIndex = GetEntityBoneIndexByName(ped,knife.bone)

            AttachEntityToEntity(weaponProp, ped, boneIndex, knife.x, knife.y, knife.z, knife.rx, knife.ry, knife.rz, true, true, false, true, 1, true)
        end

    else
        removeWeaponFromPed(ped, data.client.weapon)

        removeVariables()
    end
end)

RegisterNetEvent("nxt_inventory:currentWeapon")
AddEventHandler("nxt_inventory:currentWeapon",function(data)
    local ped = PlayerPedId()

    if weaponsSystemMods.use then
        removeWeaponFromPed(ped, weaponsSystemMods.use.weapon)

        DeleteEntity(weaponsSystemMods.entity)

        removeVariables()
    end
end)

-- RegisterNetEvent("nxt_inventory:item")
-- AddEventHandler("nxt_inventory:item",function(data1,data2,data3)
--     print(data1,data2,data3)
-- end)


Citizen.CreateThread(function()
    weaponsSystemMods.sync = {}

    while true do
        local data = GlobalState.weaponsInWorld
        local ped  = PlayerPedId()
        local cds1 = GetEntityCoords(ped)

        if data and type(data) == "table" then
            for k, v in pairs(data) do
                if v and v.owner then
                    local cds2 = GetEntityCoords(NetToEnt(v.owner))
                    local dist = #(cds1 - cds2)

                    if dist <= distanceSync and not weaponsSystemMods.sync[v.owner] and NetworkGetNetworkIdFromEntity(PlayerPedId()) ~= v.owner then
                        local __, weaponProp = createWeaponMod(NetToEnt(v.owner), v.weapon.model, v.weapon.weapon, v.weapon.knife)
                        weaponsSystemMods.sync[v.owner] = {weapon = v.weapon, owner = v.owner, entity = weaponProp}
                    end
                end
            end
        end

        for owner, data in pairs(weaponsSystemMods.sync) do
            local existsInWorld = false
            local weaponEntity  = NetToEnt(owner)
            local weaponCoords  = GetEntityCoords(weaponEntity)
            local distToWeapon  = #(cds1 - weaponCoords)

            local weaponsInWorld = GlobalState.weaponsInWorld
            if weaponsInWorld and type(weaponsInWorld) == "table" then
                for _, weaponData in pairs(weaponsInWorld) do
                    if weaponData and weaponData.owner == owner then
                        existsInWorld = true
                    end
                end
            end

            if not existsInWorld or distToWeapon > distanceSync + 10.0 then
                DeleteEntity(data.entity)

                weaponsSystemMods.sync[owner] = nil
            end
        end

        Wait(5 * 1000)
    end
end)


-- {"type":"Generic","weight":6000,"count":1,"slot":1,"close":true,"label":"Revolver .38 Roxo","stack":true,"description":"Um revolver .38 de cor roxa, raro e valioso.","client":{"clip":10,"maxClip":200,"model":"arma","typeWeapon":"rifleSystem","event":"frp_weapon:giveWeaponMod"},"name":"revolver38roxo"}

AddEventHandler('onResourceStop', function(resource) 
    if resource == GetCurrentResourceName() then 
        if weaponsSystemMods.entity then
            DeleteEntity(weaponsSystemMods.entity)
        end

        if weaponsSystemMods.sync then
            for k,v in pairs(weaponsSystemMods.sync) do
                if v.entity then
                    DeleteEntity(v.entity)
                end
            end
        end
    end
end)