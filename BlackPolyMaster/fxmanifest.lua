fx_version 'cerulean'
game 'gta5'

author 'BlackCris'
description 'PolyMaster - A coordinate & PolyZone collection tool for developers'
version '1.0.0'

-- Required dependency: ox_lib
dependency 'ox_lib'

-- Enable Lua 5.4 support (for ox_lib features like clipboard, notify, textUI)
lua54 'yes'

-- Shared exports or configuration
shared_script '@ox_lib/init.lua'

-- Client & Server entry points
client_script 'client.lua'
server_script 'server.lua'

files {
    'data/list.lua'
}
