fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'tdev_skydiving'
author 'Tdev'
description 'Cinematic group skydiving with native exits, flight instruments, deployment assistance and landing results.'
version '2.2.1'

shared_scripts {
  'config.lua',
  'shared/locales.lua',
  'shared/utils.lua'
}

client_scripts {
  'client/main.lua',
  'client/blips.lua',
  'client/target.lua',
  'client/peds.lua',
  'client/markers.lua',
  'client/menu.lua',
  'client/experience.lua',
  'client/tandem.lua',
  'client/skydiving.lua'
}

server_scripts {
  'server/logs.lua',
  'server/framework.lua',
  'server/payments.lua',
  'server/lobbies.lua',
  'server/tandem.lua',
  'server/main.lua'
}

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/app.js',
  'html/flight.js',
  'html/style.css',
  'html/images/tdev-logo.png'
}

dependencies {
  '/onesync'
}

escrow_ignore {
  'config.lua',
  'shared/*.lua',
  'html/*.html',
  'html/*.js',
  'html/*.css',
  'install/*',
  'README.md'
}
