local Proxy = module("frp_lib", "lib/Proxy")
local Tunnel = module("frp_lib", "lib/Tunnel")
cAPI = Proxy.getInterface("API")
Inventory = Tunnel.getInterface("inventory")

Abilities = Proxy.getInterface("abilities")

function Start()
    EquippedWeaponDegradationInit()
end

function Stop()
    WeaponInspectionTerminate()

    EquippedWeaponDegradationTerminate()
end

RegisterNetEvent('FRP:onCharacterLoaded', Start)
RegisterNetEvent('FRP:onCharacterLogout', Stop)

CreateThread(function()
    if cAPI.IsPlayerInitialized() then
        Start()
    end
end)

AddEventHandler('ox_inventory:weaponInspectUsed', function(itemEncoded)
    local item = itemEncoded

    if not next(item) then
        item = json.decode(itemEncoded)
    end

    local weaponHash = GetHashKey(item.name)
    local playerPed = PlayerPedId()

    if not HasPedGotWeapon(playerPed, weaponHash, 0, false) then
        exports.ox_inventory:useSlot(itemEncoded.slot)
    else
        SetCurrentPedWeapon(playerPed, weaponHash, false, 0, false, false)
    end

    assert(not gIsInspecting, 'Esse script já está sendo executado!')

    local function usedOil()
        local oil_gun = exports.ox_inventory:Search('slots', 'oil_gun')
        if oil_gun and oil_gun[1] then
            local oilGun = oil_gun[1] 
            local oilGunMetadata = oilGun.metadata
            local playerServerId = GetPlayerServerId(PlayerId())
            Inventory.SetDurability(playerServerId, oilGun.slot, (oilGunMetadata?.durability or 100) - 50)
        end
    end

    local function hasGunOil()  
        local count = exports.ox_inventory:Search('count', 'oil_gun')
        return count >= 1
    end

    -- WeaponInspectionStartInteraction(weaponHash)

    --[[ Magic number... aguardar iniciar o iteminteraction ]]
    SetTimeout(100, function()
        assert(not gIsInspecting, 'Esse script já está sendo executado!')

        -- LaunchWeaponInspecting(item)
        startWeaponInspection(hasGunOil(), usedOil)
    end)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        Stop()
    end
end)


local recoilFromLabel = {
	['weapon_pistol_m1899'] = 0.2,
	['weapon_pistol_mauser'] = 0.3,
	['weapon_pistol_mauser_drunk'] = 0.2,
	['weapon_pistol_semiauto'] = 0.3,
	['weapon_pistol_volcanic'] = 0.4,
	['weapon_revolver_cattleman'] = 0.2,
	['weapon_revolver_cattleman_john'] = 0.25,
	['weapon_revolver_cattleman_mexican'] = 0.24,
	['weapon_revolver_cattleman_pig'] = 0.3,
	['weapon_revolver_doubleaction'] = 0.4,
	['weapon_revolver_doubleaction_exotic'] = 0.5,
	['weapon_revolver_doubleaction_gambler'] = 0.2,
	['weapon_revolver_doubleaction_micah'] = 0.3,
	['weapon_revolver_lemat'] = 0.4,
	['weapon_revolver_schofield'] = 0.5,
	['weapon_revolver_schofield_golden'] = 0.5,
	['weapon_revolver_schofield_calloway'] = 0.5,
	['weapon_revolver_navy'] = 0.5,
	['weapon_repeater_winchester'] = 0.6,
	['weapon_repeater_carbine'] = 0.6,
	['weapon_repeater_evans'] = 0.6,
	['weapon_repeater_henry'] = 0.6,
	['weapon_rifle_boltaction'] = 0.6,
	['weapon_rifle_springfield'] = 0.6,
	['weapon_rifle_varmint'] = 0.6,
	['weapon_sniperrifle_carcano'] = 0.7,
	['weapon_sniperrifle_rollingblock'] = 0.7,
	['weapon_sniperrifle_rollingblock_exotic'] = 0.7,
	['weapon_shotgun_doublebarrel'] = 0.6,
	['weapon_shotgun_doublebarrel_exotic'] = 0.6,
	['weapon_shotgun_pump'] = 0.65,
	['weapon_shotgun_repeating'] = 0.65,
	['weapon_shotgun_sawedoff'] = 0.65,
	['weapon_shotgun_semiauto'] = 0.65
}


local weaponHashToName = {}
local recoilsFromHash = {}

CreateThread(function()

    for weaponName, recoil in pairs( recoilFromLabel ) do
        recoilsFromHash[ GetHashKey(weaponName) ] = recoil
        weaponHashToName[ GetHashKey(weaponName) ] = weaponName
    end
end)


local function getSkillLevelFromWeaponName( weaponHash )
    local weaponName = weaponHashToName[weaponHash]

    local normalRecoil = recoilsFromHash[ weaponHash ]

    if not weaponName then
        return
    end

    local skills = {}

    if Abilities and Abilities.getAllSkillsLevel then 
        skills = Abilities.getAllSkillsLevel()
    end 

    local myLevel = 0

    for skillName, level in pairs( skills ) do
        if string.find(weaponName:lower(), skillName:lower()) then
            myLevel = level
        end
    end

    return myLevel <= 0 and normalRecoil or normalRecoil / myLevel
end


CreateThread(function()
	while true do
        local gPlayerPed = PlayerPedId()

		if IsPedShooting(gPlayerPed) and not IsPedInAnyVehicle(gPlayerPed) then

            local _, wep = GetCurrentPedWeapon(gPlayerPed, true, 0, true)
			_,cAmmo = GetAmmoInClip(gPlayerPed, wep)

            local weaponRecoilAmount = getSkillLevelFromWeaponName( wep )

			if weaponRecoilAmount and weaponRecoilAmount ~= 0 then
				tv = 0

                local randomP = math.random(-10, 10) / 10
                
                local isFirstPerson = Citizen.InvokeNative(0xD1BA66940E94C547)
                if not isFirstPerson then
                    repeat
                        Wait(0)
                        p = GetGameplayCamRelativePitch()
        
                        SetGameplayCamRelativePitch(p + 0.1 + randomP, 0.2)

                        tv = tv + 0.1
                    until tv >= weaponRecoilAmount
                else    
                    repeat 
						Wait(0)
						p = GetGameplayCamRelativePitch()

						if weaponRecoilAmount > 0.1 then
							SetGameplayCamRelativePitch(p + 0.6 + randomP, 1.2)
							tv = tv + 0.6
						else
							SetGameplayCamRelativePitch(p + 0.016 + randomP, 0.333)
							tv = tv+0.1
						end

					until tv >= weaponRecoilAmount

                end
			end
		end

		Wait(0)
	end
end)
