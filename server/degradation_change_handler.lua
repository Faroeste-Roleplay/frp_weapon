local Proxy = module("frp_lib", "lib/Proxy")

Inventory = Proxy.getInterface("inventory")

RegisterNetEvent('net.weapondegradation.statsUpdate', function(deltaStats, weaponItemSlotId)
    local playerId = source
    local itemSlot = Inventory.GetSlot(playerId, weaponItemSlotId)

    if not itemSlot then
        return
    end

    local degradation, soot, dirt, damage in deltaStats
    local itemMetadata = itemSlot?.metadata or {}

    if degradation then
        local new = (itemMetadata.degradation or 0) + degradation

        new = math.max(new, 0.0)
        new = math.min(new, 0.5)

        itemMetadata.degradation = new
    end

    if soot then
        local new = (itemMetadata.soot or 0) + soot

        new = math.max(new, 0.0)
        new = math.min(new, 0.5)

        itemMetadata.soot = new
    end

    if dirt then
        local new = (itemMetadata.dirt or 0) + dirt

        new = math.max(new, 0.0)
        new = math.min(new, 0.5)

        itemMetadata.dirt = new
    end

    if damage then
        local new = (itemMetadata.damage or 0) + damage

        new = math.max(new, 0.0)
        new = math.min(new, 0.5)

        itemMetadata.damage = new
    end

    Inventory.SetMetadata(playerId, weaponItemSlotId, itemMetadata)
end)


RegisterNetEvent("frp_weapon:cleanWeapon")
AddEventHandler("frp_weapon:cleanWeapon",function(deltaStats, weaponItemSlotId)
    local playerId = source
    local itemSlot = Inventory.GetSlot(playerId, weaponItemSlotId)

    if not itemSlot then
        return
    end

    local itemMetadata = itemSlot?.metadata or {}

    itemMetadata.degradation = (itemMetadata.degradation or deltaStats.degradation) * 0.15
    itemMetadata.soot = (itemMetadata.soot or deltaStats.soot) * 0.15
    itemMetadata.dirt = (itemMetadata.dirt or deltaStats.dirt) * 0.15
    itemMetadata.damage = (itemMetadata.damage or deltaStats.damage) * 0.15

    Inventory.SetMetadata(playerId, weaponItemSlotId, itemMetadata)
end)