function _GetWeaponDamage(weaponEntityId)
    return Citizen.InvokeNative(0x904103D5D2333977, weaponEntityId, Citizen.ResultAsFloat())
end

function _GetWeaponDegradation(weaponEntityId)
    return Citizen.InvokeNative(0x0D78E1097F89E637, weaponEntityId, Citizen.ResultAsFloat())
end

function _GetWeaponSoot(weaponEntityId)
    return Citizen.InvokeNative(0x4BF66F8878F67663, weaponEntityId, Citizen.ResultAsFloat())
end

function _GetWeaponDirt(weaponEntityId)
    return Citizen.InvokeNative(0x810E8AE9AFEA7E54, weaponEntityId, Citizen.ResultAsFloat())
end