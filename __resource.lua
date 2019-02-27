resource_manifest_version "05cfa83c-a124-4cfa-a768-c24a5811d8f9"

version '3.1REVAMP (DEV)'

client_scripts {
    '@es_extended/locale.lua',
    "config/shared.lua",
    "client/client.lua"
}

server_scripts {
    '@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
    "config/shared.lua",
    "server/server.lua"
}

dependency 'es_extended'

ui_page 'client/html/ui.html'

files {
    'client/html/ui.html',
    'client/html/css/ui.css',
    'client/html/scripts/ui.js',
    'client/html/scripts/sounds.js',
    'client/html/images/keyfob_viper.png',
    'client/html/sounds/lock-inside.ogg',
	'client/html/sounds/lock-outside.ogg',
    'client/html/sounds/unlock-inside.ogg',
    'client/html/sounds/unlock-outside.ogg',
    'client/html/sounds/beep.ogg'
}

exports {
  'doLockSystemToggleLocks'
}
