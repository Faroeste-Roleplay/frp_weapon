local function GetCurrentPedWeaponEntityIndex(ped, p1)
	return Citizen.InvokeNative(0x3B390A939AF0B5FC, ped, p1)
end

local function SetPlayerCanMercyKill(playerId, p1)
	return Citizen.InvokeNative(0x39363DFD04E91496, playerId, p1)
end

local GiveWeaponComponentToEntity = function(...)
	return Citizen.InvokeNative(0x74C9090FDD1BB48E, ...)
end

local GetWeaponComponentTypeModel = function(...)
	return Citizen.InvokeNative(0x59DE03442B6C9598, ...)
end

local GetPedWeaponObject = function(...)
	return Citizen.InvokeNative(0x6CA484C9A7377E4F, ...)
end

local RemoveWeaponComponentFromPed = function(...)
	return Citizen.InvokeNative(0x19F70C4D80494FF8, ...)
end

local function ItemdatabaseGetBundleId(WeaponHash)
	return Citizen.InvokeNative(0x891A45960B6B768A, WeaponHash)
end

local function ItemdatabaseGetBundleItemCount(BoundleItemId, BoundleInfo)
	return Citizen.InvokeNative(0x3332695B01015DF9, BoundleItemId, BoundleInfo)
end

local function ItemdatabaseGetBundleItemInfo(BoundleItemId, BoundleInfoStruct, var0, WeaponComponentStruct)
	return Citizen.InvokeNative(0x5D48A77E4B668B57, BoundleItemId, BoundleInfoStruct, var0, WeaponComponentStruct)
end

local function GetDefaultItemSlotInfo(...)
	return Citizen.InvokeNative(0x6452B1D357D81742, ...)
end

local function ItemHaveTag(componentHash)
	return Citizen.InvokeNative(0xFF5FB5605AD56856, componentHash, 1844906744, 1120943070)
end

local attachPoints = {
	WEAPON_ATTACH_POINT_INVALID = -1,
	WEAPON_ATTACH_POINT_HAND_PRIMARY = 0,
	WEAPON_ATTACH_POINT_HAND_SECONDARY = 1,
	WEAPON_ATTACH_POINT_PISTOL_R = 2,
	MAX_HAND_WEAPON_ATTACH_POINTS = 2,
	WEAPON_ATTACH_POINT_PISTOL_L = 3,
	WEAPON_ATTACH_POINT_KNIFE = 4,
	WEAPON_ATTACH_POINT_LASSO = 5,
	WEAPON_ATTACH_POINT_THROWER = 6,
	WEAPON_ATTACH_POINT_BOW = 7,
	WEAPON_ATTACH_POINT_BOW_ALTERNATE = 8,
	WEAPON_ATTACH_POINT_RIFLE = 9,
	WEAPON_ATTACH_POINT_RIFLE_ALTERNATE = 10,
	WEAPON_ATTACH_POINT_LANTERN = 11,
	WEAPON_ATTACH_POINT_TEMP_LANTERN = 12,
	WEAPON_ATTACH_POINT_MELEE = 13,
	MAX_SYNCED_WEAPON_ATTACH_POINTS = 13,
	WEAPON_ATTACH_POINT_HIP = 14,
	WEAPON_ATTACH_POINT_BOOT = 15,
	WEAPON_ATTACH_POINT_BACK = 16,
	WEAPON_ATTACH_POINT_FRONT = 17,
	WEAPON_ATTACH_POINT_SHOULDERSLING = 18,
	WEAPON_ATTACH_POINT_LEFTBREAST = 19,
	WEAPON_ATTACH_POINT_RIGHTBREAST = 20,
	WEAPON_ATTACH_POINT_LEFTARMPIT = 21,
	WEAPON_ATTACH_POINT_RIGHTARMPIT = 22,
	WEAPON_ATTACH_POINT_LEFTARMPIT_RIFLE = 23,
	WEAPON_ATTACH_POINT_SATCHEL = 24,
	WEAPON_ATTACH_POINT_LEFTARMPIT_BOW = 25,
	WEAPON_ATTACH_POINT_RIGHT_HAND_EXTRA = 26,
	WEAPON_ATTACH_POINT_LEFT_HAND_EXTRA = 27,
	WEAPON_ATTACH_POINT_RIGHT_HAND_AUX = 28,
	MAX_WEAPON_ATTACH_POINTS = 29
};

local function ItemdatabaseIsKeyValid(weaponHash, unk)
	return Citizen.InvokeNative(0x6D5D51B188333FD1, weaponHash, unk)
end

local function ItemdatabaseFilloutItemInfo(ItemHash)
	local eventDataStruct = DataView.ArrayBuffer(8 * 8)
	local is_data_exists = Citizen.InvokeNative(0xFE90ABBCBFDC13B2, ItemHash, eventDataStruct:Buffer())
	if not is_data_exists then
		return false
	end
	return eventDataStruct
end

local function getGuidFromItemId(inventoryId, itemData, category, slotId)
	local outItem = DataView.ArrayBuffer(8 * 13)
	local success = Citizen.InvokeNative(0x886DFD3E185C8A89, inventoryId, itemData and itemData or 0, category, slotId,
		outItem:Buffer())
	return success and outItem or nil;
end

local function InventoryAddItemWithGuid(inventoryId, itemData, parentItem, itemHash, slotHash, amount, addReason)
	return Citizen.InvokeNative(0xCB5D11F9508A928D, inventoryId, itemData, parentItem, itemHash, slotHash, amount,
		addReason);
end

local function InventoryEquipItemWithGuid(inventoryId, itemData, bEquipped)
	return Citizen.InvokeNative(0x734311E2852760D0, inventoryId, itemData, bEquipped)
end

-- function removeAllWeaponComponents(weaponHash, weaponObject)
-- 	local BoundleInfoStruct = DataView.ArrayBuffer(8 * 8)
-- 	BoundleInfoStruct:SetInt32(0 * 8, 1)
-- 	local WeaponComponentStruct = DataView.ArrayBuffer(8 * 8)
-- 	local BundleItemId = ItemdatabaseGetBundleId(weaponHash)
-- 	if BundleItemId ~= 0 then
-- 		local WeaponComponentsCount = ItemdatabaseGetBundleItemCount(BundleItemId, BoundleInfoStruct:Buffer())
-- 		local var0 = 0

-- 		if WeaponComponentsCount == false then return end

-- 		while var0 < WeaponComponentsCount do
-- 			if ItemdatabaseGetBundleItemInfo(BundleItemId, BoundleInfoStruct:Buffer(), var0,
-- 					WeaponComponentStruct:Buffer()) then
-- 				local ItemInfoStruct = ItemdatabaseFilloutItemInfo(WeaponComponentStruct:GetInt32(0 * 8))
-- 				if not ItemInfoStruct then
-- 					return
-- 				end

-- 				local weaponComponent = ItemInfoStruct:GetInt32(0 * 8)
-- 				local weaponModType = ItemInfoStruct:GetInt32(2 * 8)

-- 				if weaponModType == joaat("WEAPON_MOD") or weaponModType == joaat("WEAPON_DECORATION") then
-- 					--if HasWeaponGotWeaponComponent(weaponObject, weaponComponent) then
-- 					RemoveWeaponComponentFromPed(PlayerPedId(), weaponComponent, weaponHash)
-- 					--end
-- 					--Wait(1)
-- 				end
-- 			end
-- 			var0 = var0 + 1
-- 		end
-- 	end
-- 	Wait(10)
-- end

local function findWeaponComponent( weaponComponents, stockGrip ) 
	return table.find(weaponComponents, function(item)
        return string.find(item:lower(), stockGrip:lower())
    end)
end

local function addWeaponInventoryItem(itemHash, slotHash, weaponData, componentType, gripReplaced)
	-- print(" addWeaponInventoryItem ", itemHash, slotHash, weaponData, componentType)
	local weaponHash = joaat(weaponData.name)
	local weaponName = weaponData.name:lower()
	local addReason = joaat("ADD_REASON_DEFAULT")
	local inventoryId = 1 -- INVENTORY_SP_PLAYER

	local isValid = ItemdatabaseIsKeyValid(itemHash, 0)
	if not isValid then
		return false
	end

	local characterItem = getGuidFromItemId(inventoryId, nil, joaat("CHARACTER"), 0xA1212100);
	if not characterItem then return false end

	local unkStruct = getGuidFromItemId(inventoryId, characterItem:Buffer(), 923904168, joaat('SLOTID_CARRIED_WEAPONS'));
	if not unkStruct then return false end

	local weaponItem = getGuidFromItemId(inventoryId, unkStruct:Buffer(), weaponHash, -1591664384);

	if not weaponItem then return false end

	-- WE CANT DO SAME FOR WRAP TINT IDK WHY BUT WORKS WITHOUT THIS
	local gripItem
	local gripBuffer

	if slotHash == 0x57575690  then
		local _, weaponType, weaponNameSpecifier, specialtyWeaponNameModifier = string.strsplit('_', weaponName)
		if not weaponNameSpecifier then return components, false end

		local stockName = "COMPONENT_%s_%s_GRIP"
		if weaponName == 'weapon_shotgun_repeating' then stockName = "COMPONENT_%s_%s01_GRIP" end
		if weaponName == 'weapon_sniperrifle_carcano' then weaponType = 'rifle' end

		local baseStock = (stockName):format(weaponType:upper(), weaponNameSpecifier:upper())

		if specialtyWeaponNameModifier then
			baseStock = ('COMPONENT_%s_%s_GRIP_%s'):format(weaponType:upper(), weaponNameSpecifier:upper(), specialtyWeaponNameModifier:upper())
		end

		local gripItem = findWeaponComponent( weaponData.metadata.components, baseStock )
		local gripItemName = gripItem and joaat(gripItem) or baseStock

		-- print(" gripItemName ", gripItemName, gripItem)

		gripItem = getGuidFromItemId(inventoryId, weaponItem:Buffer(), gripItemName, -1591664384)

		-- print( " gripItem ", gripItem, itemHash )

		gripBuffer = gripItem:Buffer()

		if not gripItem then return false end
	end

	local itemData = DataView.ArrayBuffer(8 * 13)
    -- print(" H ", slotHash == 0x57575690, gripItem, itemHash)

	local isAdded = InventoryAddItemWithGuid(inventoryId, itemData:Buffer(), (slotHash == 0x57575690) and gripBuffer or weaponItem:Buffer(), itemHash, slotHash, 1, addReason);
	-- print(" isAdded", isAdded)

	if not isAdded then return false end
	
	local equipped = InventoryEquipItemWithGuid(inventoryId, itemData:Buffer(), true);

	return equipped
end

local function findWeaponAtAttachmentPoint(weaponData)
	local weaponObject
    local weaponGroupType = GetWeapontypeGroup(joaat(weaponData.name))
    if weaponGroupType == `LONGARM` or weaponGroupType == `SHOTGUN` then
		local riflePoint = 'WEAPON_ATTACH_POINT_RIFLE'
		weaponObject = GetCurrentPedWeaponEntityIndex(PlayerPedId(), attachPoints[riflePoint])

		if not weaponObject then
			riflePoint = 'WEAPON_ATTACH_POINT_RIFLE_ALTERNATE'
			weaponObject = GetCurrentPedWeaponEntityIndex(PlayerPedId(), attachPoints[riflePoint])
		end
	else
		weaponObject = GetCurrentPedWeaponEntityIndex(PlayerPedId(), attachPoints['WEAPON_ATTACH_POINT_PISTOL_R'])
		if not weaponObject then
			weaponObject = GetCurrentPedWeaponEntityIndex(PlayerPedId(), attachPoints['WEAPON_ATTACH_POINT_PISTOL_L'])
		end
	end

	return weaponObject
end

function applyWeaponComponent(weaponObject, componentData, weaponData)
	-- slot hashes
	-- longarm and shotguns: 1465341584
	--shortarm: 2145617267

	local componentHash = joaat(componentData)
	local slotHash = GetDefaultItemSlotInfo(componentHash, joaat(weaponData.name))
    local weaponGroupType = GetWeapontypeGroup(joaat(weaponData.name))

	if slotHash == -1591664384 and string.find(componentData, "grip") then
		if weaponGroupType == `LONGARM` or weaponGroupType == `SHOTGUN` then
			slotHash = 1465341584
		else
			slotHash = 2145617267
		end
	end

	local itemInfoStruct = ItemdatabaseFilloutItemInfo(componentHash)
	if not itemInfoStruct then return end
	local modType = itemInfoStruct:GetInt32(2 * 8)


	
	-- local weaponName = weaponData.name

	-- -- print(" componentData 1 ", componentData)

	-- if string.find(componentData:lower(), "_grip_") then
	-- local hasWeaponGripStockTint = joaat(findWeaponComponent( weaponData.metadata.components, "GRIPSTOCK_TINT" ))
	-- 	if hasWeaponGripStockTint then
	-- 		local _, weaponType, weaponNameSpecifier, specialtyWeaponNameModifier = string.strsplit('_', weaponName)
	-- 		-- if not weaponNameSpecifier then return components, false end

	-- 		local stockName = "COMPONENT_%s_%s_GRIP"
	-- 		if weaponName == 'weapon_shotgun_repeating' then stockName = "COMPONENT_%s_%s01_GRIP" end
	-- 		if weaponName == 'weapon_sniperrifle_carcano' then weaponType = 'rifle' end

	-- 		componentData = (stockName):format(weaponType:upper(), weaponNameSpecifier:upper())

	-- 		if specialtyWeaponNameModifier then
	-- 			componentData = ('COMPONENT_%s_%s_GRIP_%s'):format(weaponType:upper(), weaponNameSpecifier:upper(), specialtyWeaponNameModifier:upper())
	-- 		end
	-- 	end
	-- end
	
	-- print(" componentData 2 ", componentData)
	-- -- print(" modType", modType, GetHashKey("WEAPON_MOD") , GetHashKey("WEAPON_DECORATION"))

	if modType == joaat("WEAPON_MOD") then
	
		--if not HasWeaponGotWeaponComponent(weaponObject, componentHash) then
		local componentModel = GetWeaponComponentTypeModel(componentHash)

		if componentModel then lib.requestModel(componentModel, 1000) end

		addWeaponInventoryItem(componentHash, slotHash, weaponData, componentData)
		SetModelAsNoLongerNeeded(componentModel)
		--end
	elseif modType == joaat("WEAPON_DECORATION") then
		-- -- print(" p2 ", slotHash)
		
		if string.find(componentData, "GRIPSTOCK_TINT") then
			slotHash = GetHashKey("hapviwga_0x57575690")
		-- 	-- print("aqui")
			-- applyWeaponComponent_2( weaponObject, GetHashKey(componentData), 0x57575690)
		-- else
		end
			addWeaponInventoryItem(componentHash, slotHash, weaponData, componentData)

		--if not HasWeaponGotWeaponComponent(weaponObject, componentHash) then --not ItemHaveTag(componentHash) and
		--	addWeaponInventoryItem(componentHash, slotHash, weaponData, componentData.type)
		--	-- 	--else
		--	-- 	--	-- print("DECORATION ALREADY LOADED")
		--end
	end
end

function applyWeaponComponent_2(WeaponObject, ComponentHash, slotHash)
    local ComponentModelHash = GetWeaponComponentTypeModel(ComponentHash)

    if not DoesEntityExist(WeaponObject) then
        -- print("Object Index for weapon does not exist! (Recovery)")
        while not DoesEntityExist(WeaponObject) do
            Wait(100)
            WeaponObject = GetCurrentPedWeaponEntityIndex(PlayerPedId(), 0)
        end
    end

    local ItemInfoStruct = ItemdatabaseFilloutItemInfo(ComponentHash)
    local ModType = ItemInfoStruct:GetInt32(2 * 8)

    if ModType == GetHashKey("WEAPON_MOD") then
        if not IsModelValid(ComponentModelHash) then
            return
        end

        RequestModel(ComponentModelHash)
        while not HasModelLoaded(ComponentModelHash) do
            Wait(0)
        end

        if not ItemHaveTag(ComponentHash) and not HasWeaponGotWeaponComponent(WeaponObject, ComponentHash) then
            addWeaponInventoryItem_2(ComponentHash, slotHash)
            -- print("LOADED MOD")
        else
            -- print("MOD ALREADY LOADED ")
        end
    elseif ModType == GetHashKey("WEAPON_DECORATION") then
        if not ItemHaveTag(ComponentHash) and not HasWeaponGotWeaponComponent(WeaponObject, ComponentHash) then
            addWeaponInventoryItem_2(ComponentHash, slotHash)
            -- print("LOADED DECORATION")
        else
            -- print("DECORATION ALREADY LOADED")
        end
    end
end

function RemoveAllWeaponComponents(WeaponHash, weaponObject, ignorePed)
    local WeaponObject = ignorePed and weaponObject or GetCurrentPedWeaponEntityIndex(PlayerPedId(), 0)
    local BoundleInfoStruct = DataView.ArrayBuffer(8 * 8)
    BoundleInfoStruct:SetInt32(0 * 8, 1)
    local WeaponComponentStruct = DataView.ArrayBuffer(8 * 8)
    local BoundleItemId = ItemdatabaseGetBundleId(WeaponHash)

    if BoundleItemId ~= 0 then
        local WeaponComponentsCount = ItemdatabaseGetBundleItemCount(BoundleItemId, BoundleInfoStruct:Buffer())
        local var0 = 0
		if WeaponComponentsCount == false then return end

		while var0 < WeaponComponentsCount do
			local res = ItemdatabaseGetBundleItemInfo(BoundleItemId, BoundleInfoStruct:Buffer(), var0, WeaponComponentStruct:Buffer())
			if res then
				local ItemInfoStruct = ItemdatabaseFilloutItemInfo(WeaponComponentStruct:GetInt32(0 * 8))

				if not ItemInfoStruct then
					return
				end

				local WeaponComponent = ItemInfoStruct:GetInt32(0 * 8)
				local WeaponModType = ItemInfoStruct:GetInt32(2 * 8)


				if WeaponModType == GetHashKey("WEAPON_MOD") or WeaponModType == GetHashKey("WEAPON_DECORATION") then
					if HasWeaponGotWeaponComponent(WeaponObject, WeaponComponent) then
						if ignorePed then
							RemoveWeaponComponentFromWeaponObject(WeaponObject, WeaponComponent)
						else
							RemoveWeaponComponentFromPed(PlayerPedId(), WeaponComponent, WeaponHash)
						end
					end
				end
			end
			var0 = var0 + 1
		end
    end

    Wait(10)
end

-- function ItemdatabaseFilloutItemInfo(ItemHash)
--     local eventDataStruct = DataView.ArrayBuffer(8 * 8)
--     local is_data_exists = Citizen.InvokeNative(0xFE90ABBCBFDC13B2, ItemHash, eventDataStruct:Buffer())
--     if not is_data_exists then
--         return false
--     end
--     return eventDataStruct
-- end

-- function RemoveWeaponComponentFromWeaponObject( weaponObject, componentHash ) 
--     return Citizen.InvokeNative(0xF7D82B0D66777611, weaponObject, componentHash)
-- end

-- function ItemdatabaseGetBundleId(WeaponHash)
--     return Citizen.InvokeNative(0x891A45960B6B768A, WeaponHash)
-- end

-- function ItemdatabaseGetBundleItemCount(BoundleItemId, BoundleInfo)
--     return Citizen.InvokeNative(0x3332695B01015DF9, BoundleItemId, BoundleInfo)
-- end

-- function ItemdatabaseGetBundleItemInfo(BoundleItemId, BoundleInfoStruct, var0, WeaponComponentStruct)
--     return Citizen.InvokeNative(0x5D48A77E4B668B57, BoundleItemId, BoundleInfoStruct, var0, WeaponComponentStruct)
-- end

-- function ItemHaveTag(ComponentHash)
--     return Citizen.InvokeNative(0xFF5FB5605AD56856, ComponentHash, 1844906744, 1120943070)
-- end

-- function GetWeaponComponentTypeModel(componentHash)
--     return Citizen.InvokeNative(0x59DE03442B6C9598, componentHash)
-- end

-- function GiveWeaponComponentToEntity(ped, componentHash, weaponHash, unk)
--     return Citizen.InvokeNative(0x74C9090FDD1BB48E, ped, componentHash, weaponHash, unk)
-- end

-- function RemoveWeaponComponentFromPed(ped, componentHash, weaponHash)
--     return Citizen.InvokeNative(0x19F70C4D80494FF8, ped, componentHash, weaponHash)
-- end

-- function RequestWeaponAsset(weaponHash)
--     return Citizen.InvokeNative(0x72D4CB5DB927009C, weaponHash, -1, 0)
-- end

-- function ItemdatabaseIsKeyValid(weaponHash, unk)
--     return Citizen.InvokeNative(0x6D5D51B188333FD1, weaponHash, unk)
-- end

-- function HasWeaponAssetLoaded(weaponHash)
--     return Citizen.InvokeNative(0xFF07CF465F48B830, weaponHash)
-- end

-- function InventoryAddItemWithGuid(inventoryId, itemData, parentItem, itemHash, slotHash, amount, addReason)
--     return Citizen.InvokeNative(0xCB5D11F9508A928D, inventoryId, itemData, parentItem, itemHash, slotHash, amount,
--         addReason);
-- end

-- function InventoryEquipItemWithGuid(inventoryId, itemData, bEquipped)
--     return Citizen.InvokeNative(0x734311E2852760D0, inventoryId, itemData, bEquipped)
-- end

-- function getGuidFromItemId(inventoryId, itemData, category, slotId)
--     local outItem = DataView.ArrayBuffer(8 * 13)
--     local success = Citizen.InvokeNative(0x886DFD3E185C8A89, inventoryId, itemData and itemData or 0, category, slotId,
--         outItem:Buffer())
--     return success and outItem or nil;
-- end

function addWeaponInventoryItem_2(itemHash, slotHash)
    local addReason = GetHashKey("ADD_REASON_DEFAULT");
    local inventoryId = 1; -- INVENTORY_SP_PLAYER

    local isValid = ItemdatabaseIsKeyValid(itemHash, 0)
    if not isValid then return false end

    local characterItem = getGuidFromItemId(inventoryId, nil, GetHashKey("CHARACTER"), 0xA1212100);
    if not characterItem then return false end

    local unkStruct = getGuidFromItemId(inventoryId, characterItem:Buffer(), 923904168, -740156546);
    if not unkStruct then return false end

    local weaponItem = getGuidFromItemId(inventoryId, unkStruct:Buffer(), GetHashKey("WEAPON_RIFLE_BOLTACTION"),
        -1591664384);
    if not weaponItem then return false end

    -- WE CANT DO SAME FOR WRAP TINT IDK WHY BUT WORKS WITHOUT THIS
    local gripItem;
    if slotHash == 0x57575690 then
        gripItem = getGuidFromItemId(inventoryId, weaponItem:Buffer(), GetHashKey("COMPONENT_RIFLE_BOLTACTION_GRIP"),
            -1591664384);
        if not gripItem then return false end
    end

    local itemData = DataView.ArrayBuffer(8 * 13)

    local isAdded = InventoryAddItemWithGuid(inventoryId, itemData:Buffer(),
        (slotHash == 0x57575690) and gripItem:Buffer() or weaponItem:Buffer(), itemHash, slotHash, 1, addReason);
    if not isAdded then return false end

    local equipped = InventoryEquipItemWithGuid(inventoryId, itemData:Buffer(), true);

    return equipped
end

-- -- function ApplyWeaponComponent(ped, weaponHash, weaponComponent)

-- -- 	local weaponObject = GetCurrentPedWeaponEntityIndex(ped, 0)
-- -- 	-- -- print(" ApplyWeaponComponent  :: ", ped, weaponHash, weaponComponent )

-- -- 	local weaponComponentHash = tonumber(weaponComponent) and tonumber(weaponComponent) or GetHashKey(weaponComponent)
-- -- 	local weapon_component_model_hash = Citizen.InvokeNative(0x59DE03442B6C9598, weaponComponentHash)

-- -- 	if weapon_component_model_hash then
-- -- 		lib.requestModel( weapon_component_model_hash )
-- -- 	end

-- -- 	-- -- print(" weapon_component_model_hash ", weapon_component_model_hash, weaponComponentHash)

-- -- 	Citizen.InvokeNative(0x74C9090FDD1BB48E, ped, joaat(weaponComponent), weaponHash, false)

-- -- 	if weapon_component_model_hash then
-- -- 		SetModelAsNoLongerNeeded(weapon_component_model_hash)
-- -- 	end
-- -- end

function GetSelectedPedWeapon(playerPed)
    local _, wep = GetCurrentPedWeapon(playerPed, true, 0, true)
    return wep
end

-- local function moveInventoryItem(inventoryId, old, new, slot)
--     local outGUID = DataView.ArrayBuffer(8 * 13)
--     if not slot then slot = 1 end
--     local sHash = "SLOTID_WEAPON_" .. tostring(slot)
--     local success = Citizen.InvokeNative(0xDCCAA7C3BFD88862, inventoryId, old, new, GetHashKey(sHash), 1,
--         outGUID:Buffer())
--     return success and outGUID or nil
-- end

-- local function getGuidFromItemId(inventoryId, itemData, category, slotId)
--     local outItem = DataView.ArrayBuffer(8 * 13)
--     local success = Citizen.InvokeNative(0x886DFD3E185C8A89, inventoryId, itemData and itemData or 0, category, slotId,
--         outItem:Buffer())
--     return success and outItem or nil
-- end

-- local equippedWeapons = {}

-- local function givePlayerWeapon(id, weaponHash, itemData, attachPoint, moveWeapon)
--     local addReason = GetHashKey("ADD_REASON_DEFAULT");
--     -- local weaponHash = GetHashKey(weaponName);
--     local ammoCount = 0;

--     -- RequestWeaponAsset
--     Citizen.InvokeNative(0x72D4CB5DB927009C, weaponHash, 0, true);

--     -- local slot = attachPoint == 3 and 0 or 1

--     Citizen.InvokeNative(0x12FB95FE3D579238, PlayerPedId(), itemData:Buffer(), true, attachPoint, false, false)

--     if moveWeapon then
--         Citizen.InvokeNative(0x12FB95FE3D579238, PlayerPedId(), equippedWeapons[1].guid, true, 1, false, false)
--     end

--     if id then
--         local nWeapon = {
--             id = id,
--             guid = itemData:Buffer(),
--         }
--         table.insert(equippedWeapons, nWeapon)
--     end
--     -- GIVE_WEAPON_TO_PED
--     -- Citizen.InvokeNative("0x5E3BDDBCB83F3D84", PlayerPedId(), weaponHash, ammoCount, false, true, attachPoint, true, 0.0, 0.0, addReason, true, 0.0, false);
-- end

-- function addWardrobeInventoryItem(id, slot, itemName, attachPoint)
--     local itemHash = GetHashKey(itemName)
--     local addReason = GetHashKey("ADD_REASON_DEFAULT")

--     local sHash = ("SLOTID_WEAPON_%s"):format(slot)
--     local slotHash = GetHashKey(sHash)

--     if slot == 0 and id then
--         if #equippedWeapons > 0 then
--             slot = 1
--         end
--     end

--     local inventoryId = 1

--     -- _ITEMDATABASE_IS_KEY_VALID
--     local isValid = Citizen.InvokeNative(0x6D5D51B188333FD1, itemHash, 0) --ItemdatabaseIsKeyValid
--     if not isValid then
--         return false
--     end

--     local characterItem = getGuidFromItemId(inventoryId, nil, GetHashKey("CHARACTER"), 0xA1212100) --return func_1367(joaat("CHARACTER"), func_2485(), -1591664384, bParam0);
--     if not characterItem then
--         -- print("no characterItem")
--         return false
--     end

--     local weaponItem = getGuidFromItemId(inventoryId, characterItem:Buffer(), 923904168, -740156546) --return func_1367(923904168, func_1889(1), -740156546, 0);
--     if not weaponItem then
--         -- print("no weaponItem")
--         return false
--     end

--     local moveWeapon = false

--     if slot == 1 and id then
--         if #equippedWeapons > 0 then
--             local newItemData = DataView.ArrayBuffer(8 * 13)
--             local newGUID = moveInventoryItem(inventoryId, equippedWeapons[1].guid, weaponItem:Buffer())
--             if not newGUID then
--                 -- print("can't move item")
--                 return false
--             end
--             slotHash = GetHashKey('SLOTID_WEAPON_0')
--             slot = 0
--             moveWeapon = true
--         else
--             slotHash = GetHashKey('SLOTID_WEAPON_0')
--             slot = 0
--         end
--     end

--     local itemData = DataView.ArrayBuffer(8 * 13)
--     -- _INVENTORY_ADD_ITEM_WITH_GUID
--     local isAdded = Citizen.InvokeNative(0xCB5D11F9508A928D, inventoryId, itemData:Buffer(), weaponItem:Buffer(),
--         itemHash, slotHash, 1, addReason)
--     if not isAdded then
--         -- print(" no isAdded ")
--         return false
--     end

--     -- _INVENTORY_EQUIP_ITEM_WITH_GUID
--     local equipped = Citizen.InvokeNative(0x734311E2852760D0, inventoryId, itemData:Buffer(), true);
--     if not equipped then
--         return false
--     end

--     return givePlayerWeapon(id, itemHash, itemData, attachPoint, moveWeapon);
-- end

-- function addWeapon(weapon, slot, id)
--     if slot == 0 and id then
--         if #equippedWeapons > 0 then
--             slot = 1
--         end
--     end
--     local weaponHash = GetHashKey(weapon)
--     local sHash = "SLOTID_WEAPON_" .. tostring(slot)
--     local reason = GetHashKey("ADD_REASON_DEFAULT")
--     local inventoryId = 1
--     local slotHash = GetHashKey(sHash)
--     local move = false

--     --Now add it to the characters inventory
--     local isValid = Citizen.InvokeNative(0x6D5D51B188333FD1, weaponHash, 0) --ItemdatabaseIsKeyValid
--     if not isValid then
--         -- print("Non valid weapon")
--         return false
--     end

--     local characterItem = getGuidFromItemId(inventoryId, nil, GetHashKey("CHARACTER"), 0xA1212100) --return func_1367(joaat("CHARACTER"), func_2485(), -1591664384, bParam0);
--     if not characterItem then
--         -- print("no characterItem")
--         return false
--     end

--     local weaponItem = getGuidFromItemId(inventoryId, characterItem:Buffer(), 923904168, -740156546) --return func_1367(923904168, func_1889(1), -740156546, 0);
--     if not weaponItem then
--         -- print("no weaponItem")
--         return false
--     end

--     if slot == 1 and id then
--         if #equippedWeapons > 0 then
--             local newItemData = DataView.ArrayBuffer(8 * 13)
--             local newGUID = moveInventoryItem(inventoryId, equippedWeapons[1].guid, weaponItem:Buffer())
--             if not newGUID then
--                 -- print("can't move item")
--                 return false
--             end
--             slotHash = GetHashKey('SLOTID_WEAPON_0')
--             slot = 0
--             move = true
--         else
--             slotHash = GetHashKey('SLOTID_WEAPON_0')
--             slot = 0
--         end
--     end

--     local itemData = DataView.ArrayBuffer(8 * 13)
--     local isAdded = Citizen.InvokeNative(0xCB5D11F9508A928D, inventoryId, itemData:Buffer(), weaponItem:Buffer(),
--         weaponHash, slotHash, 1, reason)                                                                                                         --Actually add the item now
--     if not isAdded then
--         -- print("Not added")
--         return false
--     end

--     local equipped = Citizen.InvokeNative(0x734311E2852760D0, inventoryId, itemData:Buffer(), true)
--     if not equipped then
--         -- print("no equip")
--         return false
--     end

--     Citizen.InvokeNative(0x12FB95FE3D579238, PlayerPedId(), itemData:Buffer(), true, slot, false, false)
--     if move then
--         Citizen.InvokeNative(0x12FB95FE3D579238, PlayerPedId(), equippedWeapons[1].guid, true, 1, false, false)
--     end
--     if id then
--         local nWeapon = {
--             id = id,
--             guid = itemData:Buffer(),
--         }
--         table.insert(equippedWeapons, nWeapon)
--     end

--     return true
-- end
