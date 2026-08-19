--[[
	Carrega o bridge de framework ativo (modules/bridge/<framework>/client.lua),
	que expõe cAPI/Abilities independente do core em uso.
]]

link(('@frp_weapon/modules/bridge/%s/client.lua'):format(shared.framework))
