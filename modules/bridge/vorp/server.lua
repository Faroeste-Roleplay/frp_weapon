--[[
	Bridge for VORP (vorp_core) — server side. VORP has no equivalent of
	frp_core nor of its ability/skill service, so API is reimplemented
	locally (just enough to resolve a source into a character id) and
	AbilityService.AddAbilityPoints becomes a no-op.
]]

local VORPcore

local function GetVorpCore()
	if VORPcore then return VORPcore end

	if GetResourceState('vorp_core') == 'started' then
		local ok, core = pcall(function() return exports.vorp_core:GetCore() end)

		if ok and core then
			VORPcore = core
			return VORPcore
		end
	end

	TriggerEvent('getCore', function(core)
		VORPcore = core
	end)

	return VORPcore
end

local function wrapUser(source)
	local core = GetVorpCore()
	if not core then return nil end

	local ok, User = pcall(function() return core.getUser(source) end)
	if not ok or not User then return nil end

	local self = { source = source }

	function self:GetSource() return source end

	function self:GetCharacterId()
		local Character = User.getUsedCharacter
		return Character and Character.charIdentifier
	end

	return self
end

API = {}

function API.GetUserFromSource(source)
	source = tonumber(source)
	if not source or source <= 0 then return nil end
	return wrapUser(source)
end

AbilityService = {}

-- No weapon-skill/ability system equivalent in VORP; kept as a safe no-op so
-- callers (frp:weapon:increaseSkill) don't need to know the framework.
function AbilityService.AddAbilityPoints(_charId, _category, _amount) end
