fx_version 'cerulean'
game 'gta5' 
 
shared_scripts { 
    'shared/locales.lua',
    'shared/config.lua',  
    'shared/storage.lua'
}
 
server_scripts { 
    '@async/async.lua',
    '@oxmysql/lib/MySQL.lua', 
    
    -- Main 
    'server/sv_main.lua', 
    'server/player/player.lua', 
    'server/player/classes.lua',

    -- Controllers
    'server/controllers/functions.lua',
    'server/controllers/events.lua',  
    'server/controllers/callbacks.lua',
    'server/controllers/commands.lua',  

    -- Modules 
    'server/modules/items.lua',
    'server/modules/paycheck.lua',
    'server/modules/saveplayers.lua', 
    'server/modules/friends.lua'
}

client_scripts { 
    'client/cl_main.lua', 

    -- @ Controllers 
    'client/controllers/functions.lua',
    'client/controllers/events.lua', 
    'client/controllers/commands.lua',
    'client/controllers/callbacks.lua',

    -- Modules 
    'client/modules/status.lua',
    'client/modules/player_dead.lua',
    'client/modules/glovebox.lua',
    'client/modules/skin.lua',
    'client/modules/friends.lua',
    'client/modules/noclip.lua'
}

exports {
	'getCoreData'
}

server_exports {
	'getCoreData'
}

dependencies {  
    'skinchanger'
}