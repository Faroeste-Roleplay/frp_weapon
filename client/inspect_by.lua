--- Weapon Inspect.
---
--- @author r4venw@TwitchRP
--- @note Requires DataView to be in scope.

if not DataView then
    print("error: DataView required")
    return
end

local function InventoryGetGuidFromItemId(inventoryId, itemDataBuffer, category, slotId, outItemBuffer) return Citizen
    .InvokeNative(0x886DFD3E185C8A89, inventoryId, itemDataBuffer, category, slotId, outItemBuffer) end
local function SetWeaponDegradation(weaponObject, float) Citizen.InvokeNative(0xA7A57E89E965D839, weaponObject, float,
        Citizen.ResultAsFloat()) end
local function SetWeaponDamage(weaponObject, float, p2) Citizen.InvokeNative(0xE22060121602493B, weaponObject, float, p2) end
local function SetWeaponDirt(weaponObject, float, p2) Citizen.InvokeNative(0x812CE61DEBCAB948, weaponObject, float, p2) end
local function SetWeaponSoot(weaponObject, float, p2) Citizen.InvokeNative(0xA9EF4AD10BDDDB57, weaponObject, float, p2) end
local function DisableControlAction(padIndex, control, disable) Citizen.InvokeNative(0xFE99B66D079CF6BC, padIndex,
        control, disable) end
local function IsPedRunningInspectionTask(ped) return Citizen.InvokeNative(0x038B1F1674F0E242, ped) end
local function SetPedBlackboardBool(ped, visibleName, value, removeTimer) return Citizen.InvokeNative(0xCB9401F918CB0F75,
        ped, visibleName, value, removeTimer) end
local function GetWeaponDamage(weaponObject) return Citizen.InvokeNative(0x904103D5D2333977, weaponObject,
        Citizen.ResultAsFloat()) end
local function GetWeaponDirt(weaponObject) return Citizen.InvokeNative(0x810E8AE9AFEA7E54, weaponObject,
        Citizen.ResultAsFloat()) end
local function GetWeaponSoot(weaponObject) return Citizen.InvokeNative(0x4BF66F8878F67663, weaponObject,
        Citizen.ResultAsFloat()) end
local function GetWeaponDegradation(weaponObject) return Citizen.InvokeNative(0x0D78E1097F89E637, weaponObject,
        Citizen.ResultAsFloat()) end
local function GetWeaponPermanentDegradation(weaponObject) return Citizen.InvokeNative(0xD56E5F336C675EFA, weaponObject,
        Citizen.ResultAsFloat()) end
local function GetWeaponName(weaponHash) return Citizen.InvokeNative(0x89CF5FF3D363311E, weaponHash,
        Citizen.ResultAsString()) end
local function GetWeaponNameWithPermanentDegradation(weaponHash, value) return Citizen.InvokeNative(0x7A56D66C78D8EF8E,
        weaponHash, value, Citizen.ResultAsString()) end
local function IsEntityDead(entity) return Citizen.InvokeNative(0x7D5B1F88E7504BBA, entity) end
local function IsPedSwimming(ped) return Citizen.InvokeNative(0x9DE327631295B4C2, ped) end
local function IsWeaponOneHanded(hash) return Citizen.InvokeNative(0xD955FEE4B87AFA07, hash) end
local function IsWeaponTwoHanded(hash) return Citizen.InvokeNative(0x0556E9D2ECF39D01, hash) end
local function GetObjectIndexFromEntityIndex(entity) return Citizen.InvokeNative(0x280BBE5601EAA983, entity) end
local function GetCurrentPedWeaponEntityIndex(ped, attachPoint) return Citizen.InvokeNative(0x3B390A939AF0B5FC, ped,
        attachPoint) end
local function GetItemInteractionFromPed(ped) return Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, ped) end

local function getGuidFromItemId(inventoryId, itemData, category, slotId)
    local outItem = DataView.ArrayBuffer(4 * 8)

    -- INVENTORY_GET_GUID_FROM_ITEMID
    local success = InventoryGetGuidFromItemId(inventoryId, itemData or 0, category, slotId, outItem:Buffer())

    return success and outItem or nil
end

--- Gets the native weapon condition text for a weapon object
---@param weaponObject Entity Entity ID of the weapon object to check
---@return string Condition of the weapon
local function getWeaponConditionText(weaponObject)
    local weaponDegradation = GetWeaponDegradation(weaponObject)
    local weaponPermanentDegradation = GetWeaponPermanentDegradation(weaponObject)

    if weaponDegradation == 0.0 then
        return GetStringFromHashKey(1803343570 --[[ GXTEntry: "Weapon is clean" ]])
    end
    if weaponPermanentDegradation > 0.0 and weaponDegradation == weaponPermanentDegradation then
        return GetStringFromHashKey(-1933427003 --[[ GXTEntry: "Weapon cannot be cleaned further" ]])
    end

    return GetStringFromHashKey(-54957657 --[[ GXTEntry: "Weapon needs cleaning" ]])
end

--- Queries the native inventory for weapon metadata
---@param weaponHash Hash Hash of weapon to query for
---@return DataView Struct with weapon metadata
local function getWeaponStruct(weaponHash)
    local charStruct = getGuidFromItemId(1, nil, GetHashKey("CHARACTER"), -1591664384)
    local unkStruct = getGuidFromItemId(1, charStruct:Buffer(), 923904168, -740156546)
    local weaponStruct = getGuidFromItemId(1, unkStruct:Buffer(), weaponHash, -1591664384)

    return weaponStruct
end

--- Tear down native UI system for weapon inspection
---@param uiFlowBlock Hash Reference to the native UI flow block (currently unused until I can figure out how to properly tear down without it crashing)
---@param uiContainer Hash Reference to the native UI container
local function cleanupInspectionMenu(uiFlowBlock, uiContainer)
    Citizen.InvokeNative(0x4EB122210A90E2D8, -813354801)
    DatabindingRemoveDataEntry(uiContainer)
    --ReleaseFlowBlock(uiFlowBlock) --Citizen.InvokeNative(0xF320A77DD5F781DF, uiFlowBlock)
    Citizen.InvokeNative(0x8BC7C1F929D07BF3, GetHashKey("HUD_CTX_INSPECT_ITEM")) -- DisableHUDComponent
end

--- Gets weapon display name, taking into account permanent degradation
---@param weaponHash Hash Hash of current weapon
---@param weaponObject Entity ID of current weapon object
---@return Hash Proper weapon display name
local function getWeaponDisplayName(weaponHash, weaponObject)
    local permDegradation = GetWeaponPermanentDegradation(weaponObject)
    local weaponName

    if permDegradation > 0.0 then
        weaponName = GetWeaponNameWithPermanentDegradation(weaponHash, permDegradation)
    else
        weaponName = GetWeaponName(weaponHash)
    end

    return GetHashKey(weaponName)
end

--- Updates the native UI weapon stats panel
---@param player Ped Current player
---@param uiContainer Hash Reference to ui container object of native ui
---@param weaponHash Hash Hash of weapon currently being inspected
---@param weaponObject Entity Entity ID of the weapon object in question
local function updateWeaponStats(player, uiContainer, weaponHash, weaponObject)
    Citizen.InvokeNative(0x46DB71883EE9D5AF, uiContainer, "stats", getWeaponStruct(weaponHash):Buffer(), player)
    DatabindingAddDataHash(uiContainer, "itemLabel", getWeaponDisplayName(weaponHash, weaponObject))
    DatabindingAddDataString(uiContainer, "tipText", getWeaponConditionText(weaponObject))
end

--- Initialize the overall native UI system
---@param player Ped Current player
---@param weaponHash Hash Hash of weapon to be inspected
---@param weaponObject Entity Entity ID of weapon to be inspected
---@return Hash, Hash The native UI flow block and the native UI container
local function initialize(player, weaponHash, weaponObject)
    local uiFlowBlock = RequestFlowBlock(GetHashKey("PM_FLOW_WEAPON_INSPECT"))

    local uiContainer = DatabindingAddDataContainerFromPath("", "ItemInspection")
    DatabindingAddDataBool(uiContainer, "Visible", true)
    updateWeaponStats(player, uiContainer, weaponHash, weaponObject)

    --Citizen.InvokeNative(0x10A93C057B6BD944, uiFlowBlock)
    --Citizen.InvokeNative(0x3B7519720C9DCB45, uiFlowBlock, 0)
    --Citizen.InvokeNative(0x4C6F2C4B7A03A266, -813354801, uiFlowBlock)

    Citizen.InvokeNative(0x4CC5F2FC1332577F, GetHashKey("HUD_CTX_INSPECT_ITEM"))

    return uiFlowBlock, uiContainer
end

--- Checks if player is still inspecting gun and should continue the state machine
---@param player Ped PlayerPedId
---@return boolean whether to continue or not
local function shouldContinue(player)
    if IsEntityDead(player) then
        return false
    elseif IsPedSwimming(player) then
        ClearPedTasks(player, true, false)
        return false
    elseif not IsPedRunningInspectionTask(player) then
        return false
    end

    return true
end

--- Clamps input float to a max of 1.0 and min of 0.0
---@param num number A float
---@return number A float between 0.0 and 1.0 inclusive
local function clamp(num)
    if num > 1.0 then
        return 1.0
    elseif num < 0.0 then
        return 0.0
    else
        return num
    end
end

--- Enables the clean prompt if the gun is dirty and the player has gun oil in their inventory.
---@param player Ped Current player
---@param weaponObject Entity Entity ID of the weapon object to check
---@param hasGunOil boolean Whether or not the player has gun oil
local function toggleCleanPrompt(player, weaponObject, hasGunOil)
    if hasGunOil and GetWeaponDegradation(weaponObject) ~= 0 and GetWeaponDegradation(weaponObject) > GetWeaponPermanentDegradation(weaponObject) then
        SetPedBlackboardBool(player, "GENERIC_WEAPON_CLEAN_PROMPT_AVAILABLE", 1, -1)
    else
        SetPedBlackboardBool(player, "GENERIC_WEAPON_CLEAN_PROMPT_AVAILABLE", 0, -1)
    end
end

--- Fully clean the weapon object
---@param weaponObject Entity Entity ID of the weapon to be cleaned
local function cleanWeaponObject(weaponObject)
    local d = GetWeaponPermanentDegradation(weaponObject)
    SetWeaponDegradation(weaponObject, d)
    SetWeaponDamage(weaponObject, d, false)
    SetWeaponDirt(weaponObject, 0.0, false)
    SetWeaponSoot(weaponObject, 0.0, false)
end

--- Creates a native UI state machine
---@param uiFlowBlock Hash Reference to native UI flow block
---@return number State to move to
local function createStateMachine(uiFlowBlock)
    if not Citizen.InvokeNative(0x10A93C057B6BD944, uiFlowBlock) --[[ UIFLOWBLOCK_IS_LOADED ]] then
        print("uiflowblock failed to load")
        return 0
    end

    Citizen.InvokeNative(0x3B7519720C9DCB45, uiFlowBlock, 0) -- UIFLOWBLOCK_ENTER

    if not Citizen.InvokeNative(0x5D15569C0FEBF757, -813354801) --[[ UI_STATE_MACHINE_EXISTS ]] then
        if not Citizen.InvokeNative(0x4C6F2C4B7A03A266, -813354801, uiFlowBlock) --[[ UI_STATE_MACHINE_CREATE ]] then
            print("uiflowblock wasn't created")
            return 0
        end
    end

    return 1
end

-- To make currently held weapon dirty, use:
-- crun Citizen.InvokeNative(0xA7A57E89E965D839, GetObjectIndexFromEntityIndex(GetCurrentPedWeaponEntityIndex(PlayerPedId(), 0)), 0.3)

--- Starts the weapon inspect state machine
---@param hasGunOil boolean whether the player has gun oil or not
---@param takeGunOilCallback function|nil callback function that is called when gun oil is used
function startWeaponInspection(hasGunOil, takeGunOilCallback)
    local player = PlayerPedId()
    local _, weaponHash = GetCurrentPedWeapon(player, true, 0, true)
    local interaction

    if IsWeaponOneHanded(weaponHash) then
        interaction = GetHashKey("SHORTARM_HOLD_ENTER")
    elseif IsWeaponTwoHanded(weaponHash) then
        interaction = GetHashKey("LONGARM_HOLD_ENTER")
    end

    TaskItemInteraction(player, weaponHash, interaction, 1, 0, 0)

    local weaponObject = GetObjectIndexFromEntityIndex(GetCurrentPedWeaponEntityIndex(player, 0))
    local initialWeaponDegradation = clamp(GetWeaponDegradation(weaponObject) - GetWeaponPermanentDegradation(weaponObject))
    local initialWeaponDamage = clamp(GetWeaponDamage(weaponObject) - GetWeaponPermanentDegradation(weaponObject))
    local initialWeaponDirt = GetWeaponDirt(weaponObject)
    local initialWeaponSoot = GetWeaponSoot(weaponObject)
    local uiFlowBlock, uiContainer = initialize(player, weaponHash, weaponObject)

    if uiContainer then
        local state = createStateMachine(uiFlowBlock)

        while shouldContinue(player) do
            DisableControlAction(0, GetHashKey("INPUT_NEXT_CAMERA"), true)
            --disables aim
            DisableControlAction(0, GetHashKey("INPUT_CONTEXT_LT"), true)

            if state == 0 then
                state = createStateMachine(uiFlowBlock)
            elseif state == 1 then
                toggleCleanPrompt(player, weaponObject, hasGunOil)
                if GetItemInteractionFromPed(player) == GetHashKey("LONGARM_CLEAN_ENTER") or GetItemInteractionFromPed(player) == GetHashKey("SHORTARM_CLEAN_ENTER") then
                    if takeGunOilCallback then takeGunOilCallback() end
                    state = 2
                end
            elseif state == 2 then
                if GetItemInteractionFromPed(player) == GetHashKey("LONGARM_CLEAN_EXIT") or GetItemInteractionFromPed(player) == GetHashKey("SHORTARM_CLEAN_EXIT") then
                    state = 3
                else
                    local cleanProgress = Citizen.InvokeNative(0xBC864A70AD55E0C1, PlayerPedId(),
                        GetHashKey("INPUT_CONTEXT_X"), Citizen.ResultAsFloat())
                    if cleanProgress > 0.0 then
                        local weaponPermanentDegradation = GetWeaponPermanentDegradation(weaponObject)
                        local weaponDegradation = (initialWeaponDegradation + weaponPermanentDegradation) -
                        (cleanProgress * initialWeaponDegradation)
                        local weaponDamage = (initialWeaponDamage + weaponPermanentDegradation) -
                        (cleanProgress * initialWeaponDamage)
                        local weaponDirt = initialWeaponDirt - (cleanProgress * initialWeaponDirt)
                        local weaponSoot = initialWeaponSoot - (cleanProgress * initialWeaponSoot)

                        SetWeaponDegradation(weaponObject, weaponDegradation)
                        SetWeaponDamage(weaponObject, weaponDamage)
                        SetWeaponDirt(weaponObject, weaponDirt)
                        SetWeaponSoot(weaponObject, weaponSoot)

                        updateWeaponStats(player, uiContainer, weaponHash, weaponObject)
                    end
                end
            elseif state == 3 then
                cleanWeaponObject(weaponObject)
                updateWeaponStats(player, uiContainer, weaponHash, weaponObject)
                state = 1
            end

            Citizen.Wait(0)
        end

        cleanupInspectionMenu(uiFlowBlock, uiContainer)
    end
end

exports("startWeaponInspection", function(hasGunOil, takeGunOilCallback)
    startWeaponInspection(hasGunOil, takeGunOilCallback)
end)
