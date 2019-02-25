resource_manifest_version "05cfa83c-a124-4cfa-a768-c24a5811d8f9"

version '3.1REVAMP (DEV)'

client_scripts {
    '@es_extended/locale.lua',
    "config/shared.lua",
    "client/client.lua",
    'locales/en.lua',
    'locales/pl.lua'
}

server_scripts {
    '@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
    "config/shared.lua",
    "server/server.lua",
    'locales/en.lua',
    'locales/pl.lua'
}

dependency 'es_extended'

ui_page 'client/html/ui.html'

files {
    'client/html/ui.html',
    'client/html/css/ui.css',
    'client/html/scripts/ui.js',
    'client/html/images/keyfob_viper.png',
    'client/html/sounds/lock.ogg',
    'client/html/sounds/unlock.ogg',
	'client/html/sounds/lock2.ogg'
}

exports {
  'doLockSystemToggleLocks'
}

server_exports {
	'newVehicle'
}
