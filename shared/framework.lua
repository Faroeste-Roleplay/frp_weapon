--[[
	Detecta o framework ativo (frp/vorp/rsg) para que os bridges em
	modules/bridge/<framework>/ possam expor API/cAPI/AbilityService/Abilities
	sem acoplar o resto do resource a frp_core. Mesma detecção usada por
	frp_bounty_hunter/nxt_hud (framework_config/shared.lua:GetCurrentFramework).
]]

local function GetCurrentFramework()
	if GetResourceState('vorp_core') == 'started' or GetResourceState('vorp_core-lua') == 'started' then
		return 'vorp'
	end

	if GetResourceState('rsg-core') == 'started' then
		return 'rsg'
	end

	return 'frp'
end

shared = shared or {}
shared.framework = GetCurrentFramework() -- 'frp' | 'vorp' | 'rsg'
