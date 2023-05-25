fx_version   'cerulean'
use_experimental_fxv2_oal 'yes'
lua54        'yes'
game        'gta5'


name         'SY_Pausemenu'
author       'SYNO'
version      '1.3'
license      'LGPL-3.0-or-later'
repository   'https://github.com/SYNO-SY/SY_PauseMenu'
description  'A Fivem Pausemenu script.'


dependencies {
	'/server:5848',
    '/onesync',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/**',
}

shared_script 'config.lua'

client_scripts {
	'client/client.lua',
	'config.lua'
    
}

server_scripts {
	'server/server.lua',
	'config.lua'
}
