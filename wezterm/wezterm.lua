local wezterm = require('wezterm')
local Config = require('config')

local ok, is_admin = pcall(wezterm.run_child_process, { 'fltmc.exe' })
is_admin = ok and is_admin == true

require('events.window-maximize').setup()
require('events.left-status').setup()
require('events.tab-title').setup(is_admin)
require('events.new-tab-button').setup()

return Config:init()
   :append(require('config.general'))
   :append(require('config.appearance'))
   :append(require('config.fonts'))
   :append(require('config.launch'))
   :append(require('config.bindings'))
   .options
