local restoreAmount = 1.0  -- Quanto restaura a cada tempo em ms
local speed         = 120  -- Velocidade em ms quanto maior mais rapido

CreateThread(function()
    while true do
        Wait(speed)
        
        local ped       = PlayerPedId()
        local _, weapon = GetCurrentPedWeapon(ped, true, 0, true)
        local isBow     = weapon == `WEAPON_BOW` or weapon == `WEAPON_BOW_IMPROVED`
        local aiming    = IsPlayerFreeAiming(PlayerId())

        if isBow and aiming then
            Citizen.InvokeNative(0xC3D4B754C0E86B9E, ped, restoreAmount)
        end
    end
end)