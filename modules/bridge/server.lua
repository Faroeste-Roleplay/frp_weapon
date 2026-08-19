--[[
	Carrega o bridge de framework ativo (modules/bridge/<framework>/server.lua),
	que expõe API/AbilityService independente do core em uso.
]]

link(('@frp_weapon/modules/bridge/%s/server.lua'):format(shared.framework))
