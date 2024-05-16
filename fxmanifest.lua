fx_version "adamant"

description "MaveraV Store"
author "w1z4rd_"
version '0.0.1'
repository 'https://discord.gg/6xnpZqUkaP'

game "gta5"

client_scripts {
  '@maV_core/Locale.lua',
  'locales/*.lua',
  'config.lua',
  'client/client.lua',

}


server_scripts {
  '@maV_core/Locale.lua',
  'locales/*.lua',
  'config.lua',
  'server/server.lua'
}


shared_scripts {
  '@ox_lib/init.lua',
}


escrow_ignore { 
  'config.lua',
  'locales/*.lua'
}

lua54 'yes'