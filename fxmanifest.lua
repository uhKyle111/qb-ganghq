fx_version 'cerulean'
game 'gta5'

author 'YourName'
description 'Advanced Gang HQ System with Rep, Businesses, and Missions'
version '1.0.0'

shared_scripts {
    'config.lua',
    'MissionConfig.lua'
}

client_scripts {
    'client/cl_buyhq.lua',
    'client/cl_dashboard.lua',
    'client/cl_gangpanel.lua',
    'client/cl_members.lua',
    'client/cl_missions.lua'
}

server_scripts {
    'server/sv_buyhq.lua',
    'server/sv_dashboard.lua',
    'server/sv_gangpanel.lua',
    'server/sv_members.lua',
    'server/sv_missions.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/styles.css'
}
