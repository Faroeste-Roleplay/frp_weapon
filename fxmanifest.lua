fx_version 'cerulean'

game 'common'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

use_fxv2_oal 'yes'
lua54 'yes'

shared_script '@frp_lib/library/linker.lua'

client_scripts {
    'client/native_wrappers.lua',
    
    'client/main.lua',

    'client/inspect_by.lua',

    'client/degradation.lua',
    'client/inspection.lua',
}

server_script 'server/degradation_change_handler.lua'