fx_version 'cerulean'
game 'gta5'

description 'bbv-mail'
version '1.0.0'


client_scripts {
    'config.lua',
    'wrapper/cl_wrapper.lua',
    'client/client.lua',
}

server_scripts {
    'wrapper/sv_wrapper.lua',
    'server/server.lua'
}

shared_scripts {
    'config.lua',
}

data_file 'DLC_ITYP_REQUEST' 'stream/bzzz_prop_shop_locker.ytyp'

lua54 'yes'

