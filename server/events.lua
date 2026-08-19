-- API / AbilityService são fornecidos por modules/bridge/<framework>/server.lua
-- (carregado antes deste arquivo pelo fxmanifest).

local weaponGroupHashByString = {
	[`group_pistol`] = 'Pistol',
	[`group_repeater`] = 'Repeater',
	[`group_revolver`] = 'Revolver',
	[`group_rifle`] = 'Rifle',
	[`group_sniper`] = 'Rifle',
	[`group_shotgun`] = 'Shotgun',
	[`group_thrown`] = 'Thrown',
	[`group_bow`] = 'Bow',
}

RegisterNetEvent("frp:weapon:increaseSkill", function( weaponClass )
    local playerId = source
    local weaponSkill = weaponGroupHashByString[ weaponClass ]

    local User = API.GetUserFromSource( playerId )

    if not weaponSkill or not User then return end

    AbilityService.AddAbilityPoints(User:GetCharacterId(), weaponSkill, 0.01)
end)