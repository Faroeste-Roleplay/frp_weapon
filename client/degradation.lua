local SYNC_SEND_INTERVAL = 30000
local SYNC_STAT_UPDATE_THRESHOLD = 0.02

local gProcessEquippedWeaponDegradation = false

--

local gEquippedWeaponEntityId = nil

local gEquippedWeaponDegradationLastSync = nil

local gEquippedWeaponItemId = nil

local gEquippedWeaponDegradation = nil

--

--[[ Forçar um sync nesse frame. ]]
local gLastSyncSentAt = nil

function EquippedWeaponDegradationInit()
    gProcessEquippedWeaponDegradation = true

    AddEventHandler('ox_inventory:currentWeapon', function(weaponItem)
        local justEquipped = weaponItem ~= nil
        -- print(" currentWeapon :: ", weaponItem, justEquipped)

        if justEquipped then
            if HasEquippedWeapon() then
                if gEquippedWeaponEntityId then
                    --[[ Só prepara o sync caso a gente saiba o id da entidade da arma anterior. ]]
                    PrepareSync()
                end

                ClearEquippedWeapon()
            end

            -- IsWeaponAGun - A gente so quer verificar a degradação em armas de fogo.
            if N_0x705be297eebdb95d(joaat(weaponItem.name)) ~= 0 then
                SetEquippedWeapon(weaponItem.slot)
            end
        else
            if HasEquippedWeapon() then
                ClearEquippedWeapon()
            end
        end
    end)

    AddEventHandler('ox_inventory:equippedWeaponDegradationIsReady', function(weaponItemId)
        if weaponItemId == gEquippedWeaponItemId then
            gEquippedWeaponEntityId = GetCurrentPedWeaponEntityIndex(PlayerPedId(), 0)
            
            gEquippedWeaponDegradationLastSync = GetDegradationStatsForWeaponEntity(gEquippedWeaponEntityId)
        end
    end)

    CreateThread(function()
        while gProcessEquippedWeaponDegradation do
            Wait(0)
    
            if HasEquippedWeapon() and gEquippedWeaponEntityId then

                StoreEquippedWeaponDegradation()

                if (gLastSyncSentAt == nil) or (GetGameTimer() - gLastSyncSentAt) >= SYNC_SEND_INTERVAL then
                    PrepareSync()
                end
            end
        end
    end)
end

function EquippedWeaponDegradationTerminate()
    gProcessEquippedWeaponDegradation = false
end

function HasEquippedWeapon()
    return gEquippedWeaponItemId ~= nil
end

function GetDegradationStatsForWeaponEntity(weaponEntityId)
    return {
        damage      = _GetWeaponDamage(weaponEntityId),
        degradation = _GetWeaponDegradation(weaponEntityId),
        soot        = _GetWeaponSoot(weaponEntityId),
        dirt        = _GetWeaponDirt(weaponEntityId),
    }
end

function SetEquippedWeapon(inventoryItemId)
    gEquippedWeaponItemId = inventoryItemId

    gEquippedWeaponDegradation = { }
end

function ClearEquippedWeapon()
    gEquippedWeaponEntityId = nil

    gEquippedWeaponDegradationLastSync = nil

    gEquippedWeaponItemId = nil

    gEquippedWeaponDegradation = nil
end

function ComputeEquippedWeaponDegradationStatsDelta()
    local delta = { }

    for stat, value in pairs(gEquippedWeaponDegradationLastSync) do
        
        local curr = gEquippedWeaponDegradation[stat]

        if curr then
            local diff = curr - value

            if math.abs(diff) > 0.0 then
                delta[stat] = diff
            end
        end
    end

    return delta
end

function StoreEquippedWeaponDegradation()
    if not DoesEntityExist(gEquippedWeaponEntityId) then
        return
    end

    local currentStats = GetDegradationStatsForWeaponEntity(gEquippedWeaponEntityId)

    gEquippedWeaponDegradation = currentStats
end

function UpdateEquippedWeaponStoredStatsWithSyncedStatsDelta(deltaStats)
    for stat, delta in pairs(deltaStats) do
        gEquippedWeaponDegradationLastSync[stat] += delta
    end

    -- print('gEquippedWeaponDegradationLastSync', json.encode(gEquippedWeaponDegradationLastSync, { indent = true }))
end

function SendEquippedWeaponDegradationStatsDelta(deltaStats)
    local p = { }

    for stat, delta in pairs(deltaStats) do
        p[stat] = tonumber(('%.3f'):format(delta))
    end

    -- print(" p ", p, gEquippedWeaponItemId)

    TriggerServerEvent('net.weapondegradation.statsUpdate', p, gEquippedWeaponItemId)
end

function PrepareSync()
    -- print('Trying to send delta sync...')

    local delta = ComputeEquippedWeaponDegradationStatsDelta()

    UpdateEquippedWeaponStoredStatsWithSyncedStatsDelta(delta)

    if table.type(delta) ~= 'empty' then
        SendEquippedWeaponDegradationStatsDelta(delta)
    end

    gLastSyncSentAt = GetGameTimer()
end

--

--[[

# Missing
    - items unique id.

# onSwap
    - push previously equipped ItemWeaponGun DegradationState updates to sync queue
    - check if the current equipped weapon is an inventory item and that its of type ItemWeaponGun
    - store current DegradationState

# Tick
    - check every frame if any of the state's property changed and them store that.
    - check if enough time has passed to send a DegradationState update
    - send updates to server, clear sync queue (attach item's unique id)

--]]