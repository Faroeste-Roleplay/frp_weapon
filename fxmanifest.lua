fx_version 'cerulean'

game 'common'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'


shared_script '@frp_lib/library/linker.lua'
shared_script 'shared/framework.lua'

client_scripts {
    'modules/bridge/client.lua',

    'client/native_wrappers.lua',
    'client/customization.lua',

    'client/main.lua',

    'client/inspect_by.lua',

    'client/degradation.lua',
    'client/inspection.lua',
    'client/verifyWeaponTemporary.lua',
    'client/bow_system.lua',
    'client/damage_weapons.lua',
    'mods/functions.lua',
    'mods/main.lua',
}

server_script {
    'modules/bridge/server.lua',

    'server/degradation_change_handler.lua',
    'server/events.lua',
    'mods/sv_mods.lua',
}

files {
    'files/reload_speeds.meta',

    -- Bridge de framework (frp/vorp/rsg) carregado dinamicamente via link()
    -- em modules/bridge/{server,client}.lua — precisa estar em files{} para
    -- o LoadResourceFile conseguir ler/streamar o arquivo certo.
    'modules/bridge/*/server.lua',
    'modules/bridge/*/client.lua',
}

data_file 'WEAPONINFO_FILE_PATCH' 'files/reload_speeds.meta'