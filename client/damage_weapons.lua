local WeaponDamage = {
    ['WEAPON_RIFLE_ELEPHANT'] = 40.0,
}

CreateThread(function()
    while true do
        Wait(5*1000)
        local ped           = PlayerPedId()
        local _, weaponHash = GetCurrentPedWeapon(ped)

        for name, damage in pairs(WeaponDamage) do
            if GetHashKey(name) == weaponHash then
                Citizen.InvokeNative(0xD04AD186CE8BB129, PlayerId(), weaponHash, damage)
            end
        end
    end
end)
