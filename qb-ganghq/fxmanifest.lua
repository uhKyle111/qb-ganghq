fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'QB Gang Panel - Gang Management System'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/menus.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/assets/*.svg',
    'html/assets/*.png'
}

lua54 'yes'

dependency {
    'qb-core',
    'oxmysql'
}