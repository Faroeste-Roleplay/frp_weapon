--[[
	Bridge para RSG (rsg-core) — lado cliente. Mesmo raciocínio do bridge
	VORP: cAPI é reimplementado localmente e Abilities vira stub. Os eventos
	de client do RSGCore são reemitidos como FRP:onCharacterLoaded/Logout
	para que client/main.lua não precise conhecer o framework ativo.
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

RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', function()
	playerLoaded = true
	TriggerEvent('FRP:onCharacterLoaded')
end)

RegisterNetEvent('RSGCore:Client:OnPlayerUnload', function()
	playerLoaded = false
	TriggerEvent('FRP:onCharacterLogout')
end)
