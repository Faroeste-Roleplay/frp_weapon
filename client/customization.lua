
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

local function GetDefaultItemSlotInfo(...)
	return Citizen.InvokeNative(0x6452B1D357D81742, ...)
end

local function ItemHaveTag(componentHash)
	return Citizen.InvokeNative(0xFF5FB5605AD56856, componentHash, 1844906744, 1120943070)
end

local function HasWeaponGotWeaponComponent(weaponObject, componentHash)
	return Citizen.InvokeNative(0x76A18844E743BF91, weaponObject, componentHash)
end

local function RemoveWeaponComponentFromWeaponObject(weaponObject, componentHash)
	return Citizen.InvokeNative(0xF7D82B0D66777611, weaponObject, componentHash)
end

local function RequestWeaponAsset(weaponHash)
	return Citizen.InvokeNative(0x72D4CB5DB927009C, weaponHash, -1, 0)
end

local function HasWeaponAssetLoaded(weaponHash)
	return Citizen.InvokeNative(0xFF07CF465F48B830, weaponHash)
end

local function GetWeapontypeModel(weaponHash)
	return Citizen.InvokeNative(0x59C16F79E5346E3E, weaponHash, 0)
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

-- local function ItemdatabaseFilloutItemInfo(ItemHash)
-- 	local eventDataStruct = DataView.ArrayBuffer(8 * 8)
-- 	local is_data_exists = Citizen.InvokeNative(0xFE90ABBCBFDC13B2, ItemHash, eventDataStruct:Buffer())
-- 	if not is_data_exists then
-- 		return false
-- 	end
-- 	return eventDataStruct
-- end

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

local weaponLastGrip

function applyWeaponComponent(weaponObject, componentData, weaponData, slotHash)
	-- slot hashes
	-- longarm and shotguns: 1465341584
	--shortarm: 2145617267

	local componentHash = type(componentData) == "number" and componentData or joaat(componentData)
	local weaponHash = joaat(weaponData.name)

	if string.find(componentData, "_GRIP", 1, true) and not string.find(componentData, "_GRIPSTOCK_TINT_", 1, true) then
		weaponLastGrip = componentData
	end	

	-- Garante que o weapon asset esta carregado (necessario para aplicar componentes)
	if not HasWeaponAssetLoaded(weaponHash) then
		RequestWeaponAsset(weaponHash)
		local timeout = GetGameTimer() + 3000
		while not HasWeaponAssetLoaded(weaponHash) and GetGameTimer() < timeout do
			Wait(0)
		end
	end

	-- Aguarda um pouco para garantir que o weapon object esta pronto
	if not weaponObject or weaponObject == 0 then
		Wait(10)
		-- Tenta obter novamente se nao foi fornecido
		local weaponGroupType = GetWeapontypeGroup(weaponHash)
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
	end


	-- local slotHash = Citizen.InvokeNative(0x6452B1D357D81742, componentHash, weaponHash)
	-- local slotHash = GetDefaultItemSlotInfo(componentHash, weaponHash)
	-- local weaponGroupType = GetWeapontypeGroup(weaponHash)

	-- if slotHash == -1591664384 and string.find(componentData, "grip") then
	-- 	if weaponGroupType == `LONGARM` or weaponGroupType == `SHOTGUN` then
	-- 		slotHash = 1465341584
	-- 	else
	-- 		slotHash = 2145617267
	-- 	end
	-- end

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

	-- weaponHash ja foi calculado acima

	Wait(100)

	if modType == joaat("WEAPON_MOD") then
		if not ItemHaveTag(componentHash) and not HasWeaponGotWeaponComponent(weaponObject, componentHash) then
			local componentModel = GetWeaponComponentTypeModel(componentHash)

			if componentModel then lib.requestModel(componentModel, 1000) end

			local result = addWeaponInventoryItem_2(componentHash, slotHash, weaponHash, weaponLastGrip)
			if not result then
				-- ERRO ao adicionar WEAPON_MOD
			end
			SetModelAsNoLongerNeeded(componentModel)
		else
			-- WEAPON_MOD ja aplicado ou tem tag
		end
	elseif modType == joaat("WEAPON_DECORATION") then
		if string.find(componentData, "GRIPSTOCK_TINT") then
			-- slotHash = GetHashKey("hapviwga_0x57575690")
			-- local result = applyWeaponComponent_2( weaponObject, componentHash, slotHash, weaponHash)
			local result = addWeaponInventoryItem_2(componentHash, slotHash, weaponHash, weaponLastGrip, true)
			-- print(" result 2 ", result)
			return
			-- applyWeaponComponent_2( weaponObject, GetHashKey(componentData), 0x57575690)
		end
		if not ItemHaveTag(componentHash) and not HasWeaponGotWeaponComponent(weaponObject, componentHash) then
			-- local result = addWeaponInventoryItem_2(componentHash, slotHash, weaponHash, weaponLastGrip, true)
			local result = applyWeaponComponent_2( weaponObject, componentHash, slotHash, weaponHash)
			-- print(" result 3 ", result)
			if not result then
				-- ERRO ao adicionar WEAPON_DECORATION
			end
		else
			-- WEAPON_DECORATION ja aplicado ou tem tag
		end
	end
end

function applyWeaponComponent_2(WeaponObject, ComponentHash, slotHash, WeaponHash)
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
            addWeaponInventoryItem_2(ComponentHash, slotHash, WeaponHash)
            print("LOADED MOD")
        else
            -- print("MOD ALREADY LOADED ")
        end
    elseif ModType == GetHashKey("WEAPON_DECORATION") then
        if not ItemHaveTag(ComponentHash) and not HasWeaponGotWeaponComponent(WeaponObject, ComponentHash) then
            addWeaponInventoryItem_2(ComponentHash, slotHash, WeaponHash, true)
            print("LOADED DECORATION")
        else
            -- print("DECORATION ALREADY LOADED")
        end
    end
end



-- function ItemdatabaseFilloutItemInfo(ItemHash)
--     local eventDataStruct = DataView.ArrayBuffer(8 * 8)
--     local is_data_exists = Citizen.InvokeNative(0xFE90ABBCBFDC13B2, ItemHash, eventDataStruct:Buffer())
--     if not is_data_exists then
--         return false
--     end
--     return eventDataStruct
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

local function removeComponentsFromSameSlot(weaponObject, targetSlotHash, WeaponHash, excludeComponentHash)
    -- Remove componentes do mesmo slot antes de aplicar um novo
    local BoundleInfoStruct = DataView.ArrayBuffer(8 * 8)
    BoundleInfoStruct:SetInt32(0 * 8, 1)
    local WeaponComponentStruct = DataView.ArrayBuffer(8 * 8)
    local BoundleItemId = ItemdatabaseGetBundleId(WeaponHash)

    if BoundleItemId ~= 0 then
        local WeaponComponentsCount = ItemdatabaseGetBundleItemCount(BoundleItemId, BoundleInfoStruct:Buffer())
        if WeaponComponentsCount and WeaponComponentsCount > 0 then
            for var0 = 0, WeaponComponentsCount - 1 do
                local res = ItemdatabaseGetBundleItemInfo(BoundleItemId, BoundleInfoStruct:Buffer(), var0, WeaponComponentStruct:Buffer())
                if res then
                    local componentHash = WeaponComponentStruct:GetInt32(0 * 8)
                    -- Pula o componente que estamos tentando aplicar
                    if componentHash == excludeComponentHash then
                        goto continue
                    end

                    local ItemInfoStruct = ItemdatabaseFilloutItemInfo(componentHash)
                    if ItemInfoStruct then
                        local WeaponModType = ItemInfoStruct:GetInt32(2 * 8)

                        if WeaponModType == GetHashKey("WEAPON_MOD") or WeaponModType == GetHashKey("WEAPON_DECORATION") then
                            -- Verifica se o componente esta aplicado e se tem o mesmo slot
                            if HasWeaponGotWeaponComponent(weaponObject, componentHash) then
                                local componentSlotHash = GetDefaultItemSlotInfo(componentHash, WeaponHash)
                                if componentSlotHash == targetSlotHash then
                                    -- Componente do mesmo slot, remove
                                    RemoveWeaponComponentFromWeaponObject(weaponObject, componentHash)
                                end
                            end
                        end
                    end
                end
                ::continue::
            end
        end
    end
    Wait(50) -- Aguarda um pouco apos remover componentes
end

function addWeaponInventoryItem_2(itemHash, slotHash, WeaponHash, gripItemName, isDecorator)
    local addReason = GetHashKey("ADD_REASON_DEFAULT");
    local inventoryId = 1; -- INVENTORY_SP_PLAYER

    local isValid = ItemdatabaseIsKeyValid(itemHash, 0)
    if not isValid then return false end

    local characterItem = getGuidFromItemId(inventoryId, nil, GetHashKey("CHARACTER"), 0xA1212100);
    if not characterItem then return false end

    local unkStruct = getGuidFromItemId(inventoryId, characterItem:Buffer(), 923904168, -740156546);
    if not unkStruct then return false end

    local weaponItem = getGuidFromItemId(inventoryId, unkStruct:Buffer(), WeaponHash, -1591664384);
    if not weaponItem then return false end

    -- Verifica se o componente ja esta aplicado antes de tentar adicionar
    local weaponObjectCheck = GetCurrentPedWeaponEntityIndex(PlayerPedId(), 0)
    if weaponObjectCheck and HasWeaponGotWeaponComponent(weaponObjectCheck, itemHash) then
        -- Componente ja esta aplicado na arma, provavelmente ja existe no inventario
        -- Nao precisa adicionar novamente, retorna sucesso
        return true
    end

    -- Remove componentes do mesmo slot antes de adicionar o novo
    -- if weaponObjectCheck then
    --     removeComponentsFromSameSlot(weaponObjectCheck, slotHash, WeaponHash, itemHash)
    -- end

    -- WE CANT DO SAME FOR WRAP TINT IDK WHY BUT WORKS WITHOUT THIS
    local gripItem;

	-- print(" slotHash ", slotHash, 0x57575690, isDecorator)
    if isDecorator then
        gripItem = getGuidFromItemId(inventoryId, weaponItem:Buffer(), GetHashKey(gripItemName), -1591664384);
		-- print(" gripItem ", gripItem)
        if not gripItem then return false end
    end

    local itemData = DataView.ArrayBuffer(8 * 13)

    local isAdded = InventoryAddItemWithGuid(inventoryId, itemData:Buffer(),
        isDecorator and gripItem:Buffer() or weaponItem:Buffer(), itemHash, slotHash, 1, addReason);
		-- print(" isAdded ", isAdded, itemHash)

	Wait(120)

    if not isAdded then
        -- Se falhou ao adicionar, provavelmente o componente ja existe no inventario ou slot ocupado
        -- Tenta aplicar diretamente usando GiveWeaponComponentToEntity como fallback
		-- print(" has got ", HasWeaponGotWeaponComponent(weaponObjectCheck, itemHash))
        if weaponObjectCheck and not HasWeaponGotWeaponComponent(weaponObjectCheck, itemHash) then
            local componentModel = GetWeaponComponentTypeModel(itemHash)

			-- print(" componentModel ", componentModel)
            if componentModel and componentModel ~= 0 then
                RequestModel(componentModel)
                local i = 0
                while not HasModelLoaded(componentModel) and i <= 100 do
                    i = i + 1
                    Wait(0)
                end
                if HasModelLoaded(componentModel) then
					-- print(" 1 ")
                    GiveWeaponComponentToEntity(weaponObjectCheck, itemHash, WeaponHash, true)
                    SetModelAsNoLongerNeeded(componentModel)
                end
            else
					-- print(" 2")
                -- Componente sem modelo (DECORATION), tenta aplicar diretamente
   				Citizen.InvokeNative(0x74C9090FDD1BB48E, weaponObjectCheck, itemHash, -1, false)
                -- GiveWeaponComponentToEntity(weaponObjectCheck, itemHash, WeaponHash, true)
            end
        end
        -- Retorna true mesmo se falhou ao adicionar ao inventario (componente foi aplicado diretamente ou ja existe)
        -- return true
    end

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


-- local ApplyWeaponComponent = applyWeaponComponent_2

-- RegisterCommand("testarma", function(source, args)
--     Citizen.CreateThread(function()
--         local ped = PlayerPedId()
--         local _, WeaponHash = GetCurrentPedWeapon(ped, true, 0, true)

--         if WeaponHash == 0 or WeaponHash == GetHashKey("WEAPON_UNARMED") then
--             return
--         end

--         -- Carrega o asset da arma (necessario para aplicar componentes)
--         RequestWeaponAsset(WeaponHash)

--         local timeout = GetGameTimer() + 5000
--         while not HasWeaponAssetLoaded(WeaponHash) and GetGameTimer() < timeout do
--             Wait(0)
--         end

--         if not HasWeaponAssetLoaded(WeaponHash) then
--             return
--         end

--         -- WEAPON OBJECT ITS CHANGED AFTER REMOVEING COMPONENTS
--         Wait(100) -- Aguarda um pouco para garantir que o weapon object esta pronto
--         local WeaponObject = GetCurrentPedWeaponEntityIndex(PlayerPedId(), 0)

--         if not WeaponObject or WeaponObject == 0 then
--             Wait(200)
--             WeaponObject = GetCurrentPedWeaponEntityIndex(PlayerPedId(), 0)

--             if not WeaponObject or WeaponObject == 0 then
--                 return
--             end
--         end

--         local componentHash = GetHashKey("COMPONENT_SHOTGUN_BARREL_ENGRAVING_4")
--         local slotHash = GetDefaultItemSlotInfo(componentHash, WeaponHash)

--         ApplyWeaponComponent(WeaponObject, componentHash, slotHash, WeaponHash)
--     end)
-- end)


local WeaponHash

function ApplyWeaponComponent(WeaponObject, ComponentHash, slotHash)
	local ComponentModelHash = GetWeaponComponentTypeModel(ComponentHash)

	if not DoesEntityExist(WeaponObject) then
		print("Object Index for weapon does not exist! (Recovery)")
		while not DoesEntityExist(WeaponObject) do
			Wait(100)
			WeaponObject = GetCurrentPedWeaponEntityIndex(PlayerPedId(), 0)
		end
	end

	local ItemInfoStruct = ItemdatabaseFilloutItemInfo(ComponentHash)
	local ModType = ItemInfoStruct:GetInt32(2 * 8)

    local _, weaponHash = GetCurrentPedWeapon(PlayerPedId(), true, 0, true)
	WeaponHash = weaponHash

	if not slotHash then
		slotHash = Citizen.InvokeNative(0x6452B1D357D81742, ComponentHash, WeaponHash)
	end

	if ModType == GetHashKey("WEAPON_MOD") then
		if not IsModelValid(ComponentModelHash) then
			return
		end

		RequestModel(ComponentModelHash)
		while not HasModelLoaded(ComponentModelHash) do
			Wait(0)
		end

		if not ItemHaveTag(ComponentHash) and not HasWeaponGotWeaponComponent(WeaponObject, ComponentHash) then
			addWeaponInventoryItem(ComponentHash, slotHash)
			print("LOADED MOD")
		else
			print("MOD ALREADY LOADED ")
		end
	elseif ModType == GetHashKey("WEAPON_DECORATION") then
		if not ItemHaveTag(ComponentHash) and not HasWeaponGotWeaponComponent(WeaponObject, ComponentHash) then
			addWeaponInventoryItem(ComponentHash, slotHash)
			print("LOADED DECORATION")
		else
			print("DECORATION ALREADY LOADED")
		end
	end
end

-- function RemoveAllWeaponComponents()
-- 	local WeaponObject = GetCurrentPedWeaponEntityIndex(PlayerPedId(), 0)
-- 	local BoundleInfoStruct = DataView.ArrayBuffer(8 * 8)
-- 	BoundleInfoStruct:SetInt32(0 * 8, 1)
-- 	local WeaponComponentStruct = DataView.ArrayBuffer(8 * 8)
-- 	local BoundleItemId = ItemdatabaseGetBundleId(WeaponHash)
-- 	if BoundleItemId ~= 0 then
-- 		local WeaponComponentsCount = ItemdatabaseGetBundleItemCount(BoundleItemId, BoundleInfoStruct:Buffer())
-- 		local var0 = 0

-- 		while var0 < WeaponComponentsCount do
-- 			if ItemdatabaseGetBundleItemInfo(BoundleItemId, BoundleInfoStruct:Buffer(), var0,
-- 					WeaponComponentStruct:Buffer()) then
-- 				local ItemInfoStruct = ItemdatabaseFilloutItemInfo(WeaponComponentStruct:GetInt32(0 * 8))
-- 				if not ItemInfoStruct then
-- 					return
-- 				end

-- 				local WeaponComponent = ItemInfoStruct:GetInt32(0 * 8)
-- 				local WeaponModType = ItemInfoStruct:GetInt32(2 * 8)

-- 				if WeaponModType == GetHashKey("WEAPON_MOD") or WeaponModType == GetHashKey("WEAPON_DECORATION") then
-- 					if HasWeaponGotWeaponComponent(WeaponObject, WeaponComponent) then
-- 						RemoveWeaponComponentFromPed(PlayerPedId(), WeaponComponent, WeaponHash)
-- 					end
-- 				end
-- 			end
-- 			var0 = var0 + 1
-- 		end
-- 	end
-- 	Wait(100)
-- end

function ItemdatabaseFilloutItemInfo(ItemHash)
	local eventDataStruct = DataView.ArrayBuffer(8 * 8)
	local is_data_exists = Citizen.InvokeNative(0xFE90ABBCBFDC13B2, ItemHash, eventDataStruct:Buffer())
	if not is_data_exists then
		return false
	end
	return eventDataStruct
end

function ItemdatabaseGetBundleId(WeaponHash)
	return Citizen.InvokeNative(0x891A45960B6B768A, WeaponHash)
end

function ItemdatabaseGetBundleItemCount(BoundleItemId, BoundleInfo)
	return Citizen.InvokeNative(0x3332695B01015DF9, BoundleItemId, BoundleInfo)
end

function ItemdatabaseGetBundleItemInfo(BoundleItemId, BoundleInfoStruct, var0, WeaponComponentStruct)
	return Citizen.InvokeNative(0x5D48A77E4B668B57, BoundleItemId, BoundleInfoStruct, var0, WeaponComponentStruct)
end

function ItemHaveTag(ComponentHash)
	return Citizen.InvokeNative(0xFF5FB5605AD56856, ComponentHash, 1844906744, 1120943070)
end

function GetWeaponComponentTypeModel(componentHash)
	return Citizen.InvokeNative(0x59DE03442B6C9598, componentHash)
end

function GiveWeaponComponentToEntity(ped, componentHash, weaponHash, unk)
	return Citizen.InvokeNative(0x74C9090FDD1BB48E, ped, componentHash, weaponHash, unk)
end

function RemoveWeaponComponentFromPed(ped, componentHash, weaponHash)
	return Citizen.InvokeNative(0x19F70C4D80494FF8, ped, componentHash, weaponHash)
end

function RequestWeaponAsset(weaponHash)
	return Citizen.InvokeNative(0x72D4CB5DB927009C, weaponHash, -1, 0)
end

function ItemdatabaseIsKeyValid(weaponHash, unk)
	return Citizen.InvokeNative(0x6D5D51B188333FD1, weaponHash, unk)
end

function HasWeaponAssetLoaded(weaponHash)
	return Citizen.InvokeNative(0xFF07CF465F48B830, WeaponHash)
end

function InventoryAddItemWithGuid(inventoryId, itemData, parentItem, itemHash, slotHash, amount, addReason)
	return Citizen.InvokeNative(0xCB5D11F9508A928D, inventoryId, itemData, parentItem, itemHash, slotHash, amount,
		addReason);
end

function InventoryEquipItemWithGuid(inventoryId, itemData, bEquipped)
	return Citizen.InvokeNative(0x734311E2852760D0, inventoryId, itemData, bEquipped)
end

function getGuidFromItemId(inventoryId, itemData, category, slotId)
	local outItem = DataView.ArrayBuffer(8 * 13)
	local success = Citizen.InvokeNative(0x886DFD3E185C8A89, inventoryId, itemData and itemData or 0, category, slotId,
		outItem:Buffer())
	return success and outItem or nil;
end

function addWeaponInventoryItem(itemHash, slotHash)
	local addReason = GetHashKey("ADD_REASON_DEFAULT");
	local inventoryId = 1; -- INVENTORY_SP_PLAYER

	local isValid = ItemdatabaseIsKeyValid(itemHash, 0)
	if not isValid then return false end

	local characterItem = getGuidFromItemId(inventoryId, nil, GetHashKey("CHARACTER"), 0xA1212100);
	if not characterItem then return false end

	local unkStruct = getGuidFromItemId(inventoryId, characterItem:Buffer(), 923904168, -740156546);
	if not unkStruct then return false end

	local weaponItem = getGuidFromItemId(inventoryId, unkStruct:Buffer(), WeaponHash,
		-1591664384);
	if not weaponItem then return false end

	-- WE CANT DO SAME FOR WRAP TINT IDK WHY BUT WORKS WITHOUT THIS
	local gripItem;
	if slotHash == 0x57575690 then
		gripItem = getGuidFromItemId(inventoryId, weaponItem:Buffer(),
			GetHashKey("COMPONENT_REPEATER_WINCHESTER_GRIP_ENGRAVED"),
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



local WeaponHash = GetHashKey("WEAPON_RIFLE_BOLTACTION")
local weaponLastGrip = "COMPONENT_RIFLE_BOLTACTION_GRIP_ENGRAVED"

AddEventHandler("onResourceStop", function(resName)
    if resName == GetCurrentResourceName() then
        RemoveAllPedWeapons(PlayerPedId(), true, true)
    end
end)


function ItemdatabaseFilloutItemInfo(ItemHash)
    local eventDataStruct = DataView.ArrayBuffer(8 * 8)
    local is_data_exists = Citizen.InvokeNative(0xFE90ABBCBFDC13B2, ItemHash, eventDataStruct:Buffer())
    if not is_data_exists then
        return false
    end
    return eventDataStruct
end

function ItemdatabaseGetBundleId(WeaponHash)
    return Citizen.InvokeNative(0x891A45960B6B768A, WeaponHash)
end

function ItemdatabaseGetBundleItemCount(BoundleItemId, BoundleInfo)
    return Citizen.InvokeNative(0x3332695B01015DF9, BoundleItemId, BoundleInfo)
end

function ItemdatabaseGetBundleItemInfo(BoundleItemId, BoundleInfoStruct, var0, WeaponComponentStruct)
    return Citizen.InvokeNative(0x5D48A77E4B668B57, BoundleItemId, BoundleInfoStruct, var0, WeaponComponentStruct)
end

function ItemHaveTag(ComponentHash)
    return Citizen.InvokeNative(0xFF5FB5605AD56856, ComponentHash, 1844906744, 1120943070)
end

function GetWeaponComponentTypeModel(componentHash)
    return Citizen.InvokeNative(0x59DE03442B6C9598, componentHash)
end

function GiveWeaponComponentToEntity(ped, componentHash, weaponHash, unk)
    return Citizen.InvokeNative(0x74C9090FDD1BB48E, ped, componentHash, weaponHash, unk)
end

function RemoveWeaponComponentFromPed(ped, componentHash, weaponHash)
    return Citizen.InvokeNative(0x19F70C4D80494FF8, ped, componentHash, weaponHash)
end

function RequestWeaponAsset(weaponHash)
    return Citizen.InvokeNative(0x72D4CB5DB927009C, weaponHash, -1, 0)
end

function ItemdatabaseIsKeyValid(weaponHash, unk)
    return Citizen.InvokeNative(0x6D5D51B188333FD1, weaponHash, unk)
end

function HasWeaponAssetLoaded(weaponHash)
    return Citizen.InvokeNative(0xFF07CF465F48B830, WeaponHash)
end

function InventoryAddItemWithGuid(inventoryId, itemData, parentItem, itemHash, slotHash, amount, addReason)
    return Citizen.InvokeNative(0xCB5D11F9508A928D, inventoryId, itemData, parentItem, itemHash, slotHash, amount,
        addReason);
end

function InventoryEquipItemWithGuid(inventoryId, itemData, bEquipped)
    return Citizen.InvokeNative(0x734311E2852760D0, inventoryId, itemData, bEquipped)
end

function getGuidFromItemId(inventoryId, itemData, category, slotId)
    local outItem = DataView.ArrayBuffer(8 * 13)
    local success = Citizen.InvokeNative(0x886DFD3E185C8A89, inventoryId, itemData and itemData or 0, category, slotId,
        outItem:Buffer())
    return success and outItem or nil;
end

local function attachComponent(ped, compHash, weaponHash)
    local mdl = GetWeaponComponentTypeModel(compHash)
    print(mdl, compHash, weaponHash )
    if mdl and mdl ~= 0 then
        lib.requestModel(mdl)
        while not HasModelLoaded(mdl) do Wait(100) end
    end

    if IsEntityAPed(ped) then
        GiveWeaponComponentToEntity(ped, compHash, weaponHash, true)
        ApplyShopItemToPed(ped, compHash, true, true, true)
    else
        GiveWeaponComponentToEntity(ped, compHash, -1, true)
    end

    if mdl and mdl ~= 0 then
        SetModelAsNoLongerNeeded(mdl)
    end
end


-- Lógica de Inventário e Equipamento
function addWeaponInventoryItem(itemHash, slotHash)
    local addReason = GetHashKey("ADD_REASON_DEFAULT");
    local inventoryId = 1; -- INVENTORY_SP_PLAYER

    local isValid = ItemdatabaseIsKeyValid(itemHash, 0)
    if not isValid then return false end

    local characterItem = getGuidFromItemId(inventoryId, nil, GetHashKey("CHARACTER"), 0xA1212100);
    if not characterItem then return false end

    local unkStruct = getGuidFromItemId(inventoryId, characterItem:Buffer(), 923904168, -740156546);
    if not unkStruct then return false end

    local weaponItem = getGuidFromItemId(inventoryId, unkStruct:Buffer(), WeaponHash, -1591664384);
    if not weaponItem then return false end

    -- WE CANT DO SAME FOR WRAP TINT IDK WHY BUT WORKS WITHOUT THIS
    local gripItem;
    if slotHash == 0x57575690 then
        gripItem = getGuidFromItemId(inventoryId, weaponItem:Buffer(), GetHashKey(weaponLastGrip), -1591664384);
        if not gripItem then return false end
    end

    local itemData = DataView.ArrayBuffer(8 * 13)

    local isAdded = InventoryAddItemWithGuid(inventoryId, itemData:Buffer(),
        (slotHash == 0x57575690) and gripItem:Buffer() or weaponItem:Buffer(), itemHash, slotHash, 1, addReason);
    
    if not isAdded then
        return false
    end

    local equipped = InventoryEquipItemWithGuid(inventoryId, itemData:Buffer(), true);

    return equipped
end

function ApplyWeaponComponent(WeaponObject, component, slotHash, weaponHash)
    -- print(" APPLY ", WeaponObject, component, slotHash, weaponHash)

	if string.find(component, "_GRIP", 1, true) and not string.find(component, "_GRIPSTOCK_TINT_", 1, true) and not string.find(component, "_GRIPSTOCK_ENGRAVING_", 1, true) then
		weaponLastGrip = component
	end

	local ComponentHash = GetHashKey(component)

	WeaponHash = weaponHash

    local ComponentModelHash = GetWeaponComponentTypeModel(ComponentHash)

    if not slotHash or slotHash == 0 then
        slotHash = Citizen.InvokeNative(0x6452B1D357D81742, ComponentHash, weaponHash)
    end

    if not HasWeaponAssetLoaded(WeaponHash) then
        RequestWeaponAsset(WeaponHash)
        local timeout = GetGameTimer() + 3000
        while not HasWeaponAssetLoaded(WeaponHash) and GetGameTimer() < timeout do
            Wait(0)
        end
    end

    -- print(" weaponLastGrip ", weaponLastGrip)

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
            local res = addWeaponInventoryItem(ComponentHash, slotHash)
            if not res then
                attachComponent( PlayerPedId(), ComponentHash, WeaponHash)
            end
            -- print("LOADED MOD")
        else
            -- print("MOD ALREADY LOADED ")
        end
    elseif ModType == GetHashKey("WEAPON_DECORATION") then
        if not ItemHaveTag(ComponentHash) and not HasWeaponGotWeaponComponent(WeaponObject, ComponentHash) then
            local res = addWeaponInventoryItem(ComponentHash, slotHash)
            if not res then
                attachComponent( PlayerPedId(), ComponentHash, WeaponHash)
            end
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

RegisterNetEvent("frp_weapon:applyComponent", function(WeaponObject, ComponentHash, slotHash, WeaponHash)
	ApplyWeaponComponent(WeaponObject, ComponentHash, slotHash, WeaponHash)
end)


-- function RemoveAllWeaponComponents()
--     local WeaponObject = GetCurrentPedWeaponEntityIndex(PlayerPedId(), 0)
--     local BoundleInfoStruct = DataView.ArrayBuffer(8 * 8)
--     BoundleInfoStruct:SetInt32(0 * 8, 1)
--     local WeaponComponentStruct = DataView.ArrayBuffer(8 * 8)
--     local BoundleItemId = ItemdatabaseGetBundleId(WeaponHash)
--     if BoundleItemId ~= 0 then
--         local WeaponComponentsCount = ItemdatabaseGetBundleItemCount(BoundleItemId, BoundleInfoStruct:Buffer())
--         local var0 = 0

--         while var0 < WeaponComponentsCount do
--             if ItemdatabaseGetBundleItemInfo(BoundleItemId, BoundleInfoStruct:Buffer(), var0,
--                     WeaponComponentStruct:Buffer()) then
--                 local ItemInfoStruct = ItemdatabaseFilloutItemInfo(WeaponComponentStruct:GetInt32(0 * 8))
--                 if not ItemInfoStruct then
--                     return
--                 end

--                 local WeaponComponent = ItemInfoStruct:GetInt32(0 * 8)
--                 local WeaponModType = ItemInfoStruct:GetInt32(2 * 8)

--                 if WeaponModType == GetHashKey("WEAPON_MOD") or WeaponModType == GetHashKey("WEAPON_DECORATION") then
--                     if HasWeaponGotWeaponComponent(WeaponObject, WeaponComponent) then
--                         RemoveWeaponComponentFromPed(PlayerPedId(), WeaponComponent, WeaponHash)
--                     end
--                 end
--             end
--             var0 = var0 + 1
--         end
--     end
--     Wait(100)
-- end


--[[
    Default, and assumed, LUAI_MAXSHORTLEN is 40. To create a non internalized
    string always force the buffer to be greater than that value.
--]]
local _strblob = string.blob or function(length)
    return string.rep("\0", math.max(40 + 1, length))
end

--[[
    API:
        DataView::{Get | Set}Int8
        DataView::{Get | Set}Uint8
        DataView::{Get | Set}Int16
        DataView::{Get | Set}Uint16
        DataView::{Get | Set}Int32
        DataView::{Get | Set}Uint32
        DataView::{Get | Set}Int64
        DataView::{Get | Set}Uint64
        DataView::{Get | Set}LuaInt
        DataView::{Get | Set}UluaInt
        DataView::{Get | Set}LuaNum
        DataView::{Get | Set}Float32
        DataView::{Get | Set}Float64
        DataView::{Get | Set}String
            Parameters:
                Get: self, offset, endian (optional)
                Set: self, offset, value, endian (optional)
        DataView::{GetFixed | SetFixed}::Int
        DataView::{GetFixed | SetFixed}::Uint
        DataView::{GetFixed | SetFixed}::String
            Parameters:
                Get: offset, typelen, endian (optional)
                Set: offset, typelen, value, endian (optional)
    NOTES:
        (1) Endianness changed from JS API, defaults to little endian.
        (2) {Get|Set|Next} offsets are zero-based.
    EXAMPLES:
        local view = DataView.ArrayBuffer(512)
        if Citizen.InvokeNative(0x79923CD21BECE14E, 1, view:Buffer(), Citizen.ReturnResultAnyway()) then
            local dlc = {
                validCheck = view:GetInt64(0),
                weaponHash = view:GetInt32(8),
                val3 = view:GetInt64(16),
                weaponCost = view:GetInt64(24),
                ammoCost = view:GetInt64(32),
                ammoType = view:GetInt64(40),
                defaultClipSize = view:GetInt64(48),
                nameLabel = view:GetFixedString(56, 64),
                descLabel = view:GetFixedString(120, 64),
                simpleDesc = view:GetFixedString(184, 64),
                upperCaseName = view:GetFixedString(248, 64),
            }
        end
--]]
DataView = {
    EndBig = ">",
    EndLittle = "<",
    Types = {
        Int8 = { code = "i1", size = 1 },
        Uint8 = { code = "I1", size = 1 },
        Int16 = { code = "i2", size = 2 },
        Uint16 = { code = "I2", size = 2 },
        Int32 = { code = "i4", size = 4 },
        Uint32 = { code = "I4", size = 4 },
        Int64 = { code = "i8", size = 8 },
        Uint64 = { code = "I8", size = 8 },

        LuaInt = { code = "j", size = 8 },   -- a lua_Integer
        UluaInt = { code = "J", size = 8 },  -- a lua_Unsigned
        LuaNum = { code = "n", size = 8 },   -- a lua_Number
        Float32 = { code = "f", size = 4 },  -- a float (native size)
        Float64 = { code = "d", size = 8 },  -- a double (native size)
        String = { code = "z", size = -1, }, -- zero terminated string
    },

    FixedTypes = {
        String = { code = "c", size = -1, }, -- a fixed-sized string with n bytes
        Int = { code = "i", size = -1, },    -- a signed int with n bytes
        Uint = { code = "I", size = -1, },   -- an unsigned int with n bytes
    },
}
DataView.__index = DataView

--[[ Is a dataview type at a specific offset still within buffer length --]]
local function _ib(o, l, t) return ((t.size < 0 and true) or (o + (t.size - 1) <= l)) end
local function _ef(big) return (big and DataView.EndBig) or DataView.EndLittle end

--[[ Helper function for setting fixed datatypes within a buffer --]]
local SetFixed = nil

--[[ Create an ArrayBuffer with a size in bytes --]]
function DataView.ArrayBuffer(length)
    return setmetatable({
        offset = 1, length = length, blob = _strblob(length)
    }, DataView)
end

--[[ Wrap a non-internalized string --]]
function DataView.Wrap(blob)
    return setmetatable({
        offset = 1, blob = blob, length = blob:len(),
    }, DataView)
end

function DataView:Buffer() return self.blob end

function DataView:ByteLength() return self.length end

function DataView:ByteOffset() return self.offset end

function DataView:SubView(offset)
    return setmetatable({
        offset = offset, blob = self.blob, length = self.length,
    }, DataView)
end

--[[ Create the API by using DataView.Types. --]]
for label, datatype in pairs(DataView.Types) do
    DataView["Get" .. label] = function(self, offset, endian)
        local o = self.offset + offset
        if _ib(o, self.length, datatype) then
            local v, _ = string.unpack(_ef(endian) .. datatype.code, self.blob, o)
            return v
        end
        return nil -- Out of bounds
    end

    DataView["Set" .. label] = function(self, offset, value, endian)
        local o = self.offset + offset
        if _ib(o, self.length, datatype) then
            return SetFixed(self, o, value, _ef(endian) .. datatype.code)
        end
        return self -- Out of bounds
    end

    -- Ensure cache is correct.
    if datatype.size >= 0 and string.packsize(datatype.code) ~= datatype.size then
        local msg = "Pack size of %s (%d) does not match cached length: (%d)"
        error(msg:format(label, string.packsize(fmt[#fmt]), datatype.size))
        return nil
    end
end

for label, datatype in pairs(DataView.FixedTypes) do
    DataView["GetFixed" .. label] = function(self, offset, typelen, endian)
        local o = self.offset + offset
        if o + (typelen - 1) <= self.length then
            local code = _ef(endian) .. "c" .. tostring(typelen)
            local v, _ = string.unpack(code, self.blob, o)
            return v
        end
        return nil -- Out of bounds
    end

    DataView["SetFixed" .. label] = function(self, offset, typelen, value, endian)
        local o = self.offset + offset
        if o + (typelen - 1) <= self.length then
            local code = _ef(endian) .. "c" .. tostring(typelen)
            return SetFixed(self, o, value, code)
        end
        return self
    end
end

--[[ Helper function for setting fixed datatypes within a buffer --]]
SetFixed = function(self, offset, value, code)
    local fmt = {}
    local values = {}

    -- All bytes prior to the offset
    if self.offset < offset then
        local size = offset - self.offset
        fmt[#fmt + 1] = "c" .. tostring(size)
        values[#values + 1] = self.blob:sub(self.offset, size)
    end

    fmt[#fmt + 1] = code
    values[#values + 1] = value

    -- All bytes after the value (offset + size) to the end of the buffer
    -- growing the buffer if needed.
    local ps = string.packsize(fmt[#fmt])
    if (offset + ps) <= self.length then
        local newoff = offset + ps
        local size = self.length - newoff + 1

        fmt[#fmt + 1] = "c" .. tostring(size)
        values[#values + 1] = self.blob:sub(newoff, self.length)
    end

    self.blob = string.pack(table.concat(fmt, ""), table.unpack(values))
    self.length = self.blob:len()
    return self
end
