local Proxy = module("frp_lib", "lib/Proxy")
local Tunnel = module("frp_lib", "lib/Tunnel")
cAPI = Proxy.getInterface("API")
Inventory = Tunnel.getInterface("inventory")

function Start()
    EquippedWeaponDegradationInit()
end

function Stop()
    WeaponInspectionTerminate()

    EquippedWeaponDegradationTerminate()
end

RegisterNetEvent('FRP:onCharacterLoaded', Start)
RegisterNetEvent('FRP:onCharacterLogout', Stop)

CreateThread(function()
    if cAPI.IsPlayerInitialized() then
        Start()
    end
end)

AddEventHandler('ox_inventory:weaponInspectUsed', function(itemEncoded)
    local item = itemEncoded

    if not next(item) then
        item = json.decode(itemEncoded)
    end

    local weaponHash = GetHashKey(item.name)
    local playerPed = PlayerPedId()

    if not HasPedGotWeapon(playerPed, weaponHash, 0, false) then
        exports.ox_inventory:useSlot(itemEncoded.slot)
    else
        SetCurrentPedWeapon(playerPed, weaponHash, false, 0, false, false)
    end

    assert(not gIsInspecting, 'Esse script já está sendo executado!')

    local function usedOil()
        local oil_gun = exports.ox_inventory:Search('slots', 'oil_gun')
        if oil_gun and oil_gun[1] then
            local oilGun = oil_gun[1] 
            local oilGunMetadata = oilGun.metadata
            local playerServerId = GetPlayerServerId(PlayerId())
            Inventory.SetDurability(playerServerId, oilGun.slot, (oilGunMetadata?.durability or 100) - 50)
        end
    end

    local function hasGunOil()  
        local count = exports.ox_inventory:Search('count', 'oil_gun')
        return count >= 1
    end

    -- WeaponInspectionStartInteraction(weaponHash)

    --[[ Magic number... aguardar iniciar o iteminteraction ]]
    SetTimeout(100, function()
        assert(not gIsInspecting, 'Esse script já está sendo executado!')

        -- LaunchWeaponInspecting(item)
        startWeaponInspection(hasGunOil(), usedOil)
    end)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        Stop()
    end
end)