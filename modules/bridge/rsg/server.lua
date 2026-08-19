--[[
	Bridge para RSG (rsg-core) — lado servidor. Mesmo raciocínio do bridge
	VORP: sem frp_core nem sistema de habilidades equivalente, API é
	reimplementado localmente e AbilityService.AddAbilityPoints vira no-op.
]]

local RSGCore

local function GetRsgCore()
	if RSGCore then return RSGCore end

	if GetResourceState('rsg-core') == 'started' then
		local ok, core = pcall(function() return exports['rsg-core']:GetCoreObject() end)
		if ok and core then RSGCore = core end
	end

	return RSGCore
end

local function wrapUser(source)
	local core = GetRsgCore()
	if not core then return nil end

	local ok, Player = pcall(function() return core.Functions.GetPlayer(source) end)
	if not ok or not Player or not Player.PlayerData then return nil end

	local self = { source = source }

	function self:GetSource() return source end

	function self:GetCharacterId() return Player.PlayerData.citizenid end

	return self
end

API = {}

function API.GetUserFromSource(source)
	source = tonumber(source)
	if not source or source <= 0 then return nil end
	return wrapUser(source)
end

AbilityService = {}

-- Sem sistema de skill/habilidade equivalente no RSG; no-op seguro para que
-- quem chama (frp:weapon:increaseSkill) não precise saber o framework.
function AbilityService.AddAbilityPoints(_charId, _category, _amount) end
