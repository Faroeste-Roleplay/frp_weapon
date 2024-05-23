local eWeaponInspectionCleaningState =
{
    Init  = 0,
    Wait  = 1,
    Enter = 2,
    Loop  = 3,
    Exit  = 4,
}

local gIsInspecting = false

local gPlayerPedId = nil

local gWeaponInspectionCleaningState = eWeaponInspectionCleaningState.Init

--

local gAmountToClean = nil
-- local gStatsSoot = nil
-- local gStatsDirt = nil

function LaunchWeaponInspecting(item)
    gIsInspecting = true

    gPlayerPedId = PlayerPedId()

    local weaponEntityId = GetCurrentPedWeaponEntityIndex(gPlayerPedId, 0)

    local weaponHash = GetHashKey(item.name)

    -- WeaponInspectionInitUi(weaponEntityId, weaponHash, item.description or 'ITEM SEM DESCRIÇÃO!')

    while ShouldWeaponInspectingRun() do

        -- ?
        -- //0x000FA7A4A8443AF7
        -- void _UNEQUIP_WEAPONS_FROM_PED(Ped ped, int p0, BOOL immediately);
        -- N_0x000fa7a4a8443af7(weaponHash)

        local state = GetWeaponInspectionCleaningState()

        if state == 0 --[[ Init ]] then

            SetWeaponInspectionCleaningState(eWeaponInspectionCleaningState.Wait)

        elseif state == 1 --[[ Wait ]] then

            WeaponInspectionEnableCleanPrompt()

            -- GetItemInteractionState
            if N_0x6aa3dca2c6f5eb6d(gPlayerPedId) == `LONGARM_CLEAN_ENTER` or N_0x6aa3dca2c6f5eb6d(gPlayerPedId) == `SHORTARM_CLEAN_ENTER` then
                SetWeaponInspectionCleaningState(eWeaponInspectionCleaningState.Enter)
            end

        elseif state == 2 --[[ Enter ]] then
            SetWeaponInspectionCleaningState(eWeaponInspectionCleaningState.Loop)

            local cleanProgress = Citizen.InvokeNative(0xBC864A70AD55E0C1, PlayerPedId(),
            GetHashKey("INPUT_CONTEXT_X"), Citizen.ResultAsFloat())

            if cleanProgress > 0.0 then
                WeaponInspectionUpdateInformations()
            end
        elseif state == 3 --[[ Loop ]] then

            -- GetItemInteractionState
            if N_0x6aa3dca2c6f5eb6d(gPlayerPedId) == `LONGARM_CLEAN_EXIT` or N_0x6aa3dca2c6f5eb6d(gPlayerPedId) == `SHORTARM_CLEAN_EXIT` then
                SetWeaponInspectionCleaningState(eWeaponInspectionCleaningState.Exit)
            end

        elseif state == 4 --[[ Exit ]] then

            SetWeaponInspectionCleaningState(eWeaponInspectionCleaningState.Wait)

        end

        Wait(0)
    end

    WeaponInspectionTerminate()
end

function WeaponInspectionUpdateInformations(weaponEntityIdl, cleanProgress)
    local weaponDamage         = Citizen.InvokeNative(0x904103D5D2333977, weaponEntityId, Citizen.ResultAsFloat())
    local weaponDegradation    = Citizen.InvokeNative(0x0D78E1097F89E637, weaponEntityId, Citizen.ResultAsFloat())

    weaponDamage = math.min(1.0, weaponDamage)
    weaponDamage = math.max(0.0, weaponDamage)

    weaponDegradation = math.min(1.0, weaponDegradation)
    weaponDegradation = math.max(0.0, weaponDegradation)

    local weaponDirt           = Citizen.InvokeNative(0x810E8AE9AFEA7E54, weaponEntityId, Citizen.ResultAsFloat())
    local weaponSoot           = Citizen.InvokeNative(0x4BF66F8878F67663, weaponEntityId, Citizen.ResultAsFloat())

    SetWeaponDegradation(weaponEntityId, weaponDegradation - (cleanProgress * weaponDegradation))
    SetWeaponDamage(weaponEntityId, weaponDamage - (cleanProgress * weaponDamage))
    SetWeaponDirt(weaponEntityId, weaponDirt - (cleanProgress * weaponDirt))
    SetWeaponSoot(weaponEntityId, weaponSoot - (cleanProgress * weaponSoot))
end

function WeaponInspectionStartInteraction(weaponHash)
    local itemInteractionHash = `LONGARM_HOLD_ENTER`

    local weaponGroupType = GetWeapontypeGroup(weaponHash)

    if weaponGroupType == -1101297303 or weaponGroupType == 416676503 then
        itemInteractionHash = `SHORTARM_HOLD_ENTER`
    end

    SwapWeaponToPlayer(gPlayerPedId, weaponHash) 

    Wait(100)

    TaskItemInteraction(PlayerPedId(), weaponHash, itemInteractionHash, 0, 0, -1.0)
end

function WeaponInspectionInitUi(weaponEntityId, weaponHash, weaponDescription)

    local weaponPermanentDegradation = Citizen.InvokeNative(0xD56E5F336C675EFA, weaponEntityId, Citizen.ResultAsFloat())

    local weaponDamage         = Citizen.InvokeNative(0x904103D5D2333977, weaponEntityId, Citizen.ResultAsFloat())
    local weaponDegradation    = Citizen.InvokeNative(0x0D78E1097F89E637, weaponEntityId, Citizen.ResultAsFloat())

    weaponDamage = math.min(1.0, weaponDamage)
    weaponDamage = math.max(0.0, weaponDamage)

    weaponDegradation = math.min(1.0, weaponDegradation)
    weaponDegradation = math.max(0.0, weaponDegradation)

    gAmountToClean = weaponDamage

    local weaponDirt           = Citizen.InvokeNative(0x810E8AE9AFEA7E54, weaponEntityId, Citizen.ResultAsFloat())
    local weaponSoot           = Citizen.InvokeNative(0x4BF66F8878F67663, weaponEntityId, Citizen.ResultAsFloat())

    -- glow:UiAppLaunch('AppWeaponStatus', function()

    --     local weaponName = Citizen.InvokeNative(0xBD5DD5EAE2B6CE14, weaponHash, Citizen.ResultAsString())

    --     glow:UiAppEmit('AppWeaponStatus', 'UpdateWeaponStatus',
    --     {
    --         name = weaponName,
    --         description = weaponDescription,
    
    --         maxdegradation = weaponPermanentDegradation * 100,

    --         rust           = weaponDamage * 100,
    --         degradation    = weaponDegradation * 100,

    --         soot           = weaponSoot * 100,
    --         dirt           = weaponDirt * 100,
    --     })
    -- end)
end

function WeaponInspectionTerminate()
    -- print('WeaponInspectionTerminate')

    ClearPedTasks(gPlayerPedId, true, false)

    gPlayerPedId = nil

    gIsInspecting = false

    gWeaponInspectionCleaningState = eWeaponInspectionCleaningState.Init

    --

    gAmountToClean = nil

    -- glow:UiAppClose('AppWeaponStatus')
end

function ShouldWeaponInspectingRun()
    if IsEntityDead(gPlayerPedId) then
        return false
    end

    if IsPedSwimming(gPlayerPedId) then
        ClearPedTasks(gPlayerPedId, true, false)
        return false
    end

    -- IsPedRunningInspectionTask
    if N_0x038b1f1674f0e242(gPlayerPedId) == 0 then
        return false
    end

    -- GetPedBlackboardBool
    if N_0x498f2e77982d6945(gPlayerPedId, 'isInspecting') == 0 and N_0x498f2e77982d6945(gPlayerPedId, 'inInspectionMode') == 0 then
        return false
    end

    if not gIsInspecting then
        return false
    end
    -- ?

    return true
end

function GetWeaponInspectionCleaningState()
    return gWeaponInspectionCleaningState
end

function SetWeaponInspectionCleaningState(state)
    gWeaponInspectionCleaningState = state

    -- print( ('SetWeaponInspectionCleaningState :: state(%d)'):format(state) )
end

function WeaponInspectionEnableCleanPrompt()
    local weaponEntityId = GetCurrentPedWeaponEntityIndex(gPlayerPedId, 0)

    --- Acredito que deveria ter aqui um callback para checar se o usuário possúi o necessário para limpar a arma!
    local hasItemGunOil = true

    -- GetWeaponDegradation
    local weaponDegradation = Citizen.InvokeNative(0x0D78E1097F89E637, weaponEntityId, Citizen.ResultAsFloat())

    -- GetWeaponPermanentDegradation
    local weaponPermanentDegradation = Citizen.InvokeNative(0xD56E5F336C675EFA, weaponEntityId, Citizen.ResultAsFloat())

    if hasItemGunOil and (weaponDegradation ~= 0.0 and weaponDegradation > weaponPermanentDegradation) then
        -- GetPedBlackboardBool
        if N_0x498f2e77982d6945(gPlayerPedId, 'GENERIC_WEAPON_CLEAN_PROMPT_AVAILABLE') == 0 then
            -- SetPedBlackboardBool
            N_0xcb9401f918cb0f75(gPlayerPedId, 'GENERIC_WEAPON_CLEAN_PROMPT_AVAILABLE', true, -1)
        end
    else
        -- GetPedBlackboardBool
        if N_0x498f2e77982d6945(gPlayerPedId, 'GENERIC_WEAPON_CLEAN_PROMPT_AVAILABLE') ~= 0 then
            -- SetPedBlackboardBool
            N_0xcb9401f918cb0f75(gPlayerPedId, 'GENERIC_WEAPON_CLEAN_PROMPT_AVAILABLE', false, -1)
        end
    end
end


function SwapWeaponToPlayer(playerPed, weaponHash)
    
    if not HasPedGotWeapon(playerPed, weaponHash, 0, false) then
        Citizen.InvokeNative(0xB282DC6EBD803C75, playerPed, weaponHash, 0, true, 0) -- GIVE_DELAYED_WEAPON_TO_PED
    else
        SetCurrentPedWeapon(playerPed, weaponHash, false, 0, false, false)
    end

end