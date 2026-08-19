--[[
	Bridge for VORP (vorp_core) — client side. VORP has no equivalent of
	frp_core, so cAPI is reimplemented locally and Abilities is stubbed out
	(no skill/ability system to read from). vorp:SelectedCharacter is
	re-emitted as FRP:onCharacterLoaded so client/main.lua doesn't need to
	know about the active framework.
]]

local playerLoaded = false

cAPI = {}

function cAPI.IsPlayerInitialized()
	return playerLoaded
end

Abilities = {}

function Abilities.getAllSkillsLevel()
	return {}
end

RegisterNetEvent('vorp:SelectedCharacter', function()
	playerLoaded = true
	TriggerEvent('FRP:onCharacterLoaded')
end)

RegisterNetEvent('vorp:playerDropped', function()
	playerLoaded = false
	TriggerEvent('FRP:onCharacterLogout')
end)
