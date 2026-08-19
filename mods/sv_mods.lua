local weaponsInWorld = {}

RegisterNetEvent("frp_weapon:removeWeaponInWorld")
AddEventHandler("frp_weapon:removeWeaponInWorld", function(weapon, netId)
    local source               = source
    weaponsInWorld[netId]      = nil
    GlobalState.weaponsInWorld = weaponsInWorld
end)

RegisterNetEvent("frp_weapon:addWeaponInWorld")
AddEventHandler("frp_weapon:addWeaponInWorld", function(weapon, netId)
    local source               = source
    weaponsInWorld[netId]      = {weapon = weapon, owner = netId}
    GlobalState.weaponsInWorld = weaponsInWorld
end)