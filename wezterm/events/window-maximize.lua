local wezterm = require('wezterm')
local mux = wezterm.mux

local M = {}

local function first_time(window_id)
   local key = 'maximized_' .. window_id
   if wezterm.GLOBAL[key] then
      return false
   end
   wezterm.GLOBAL[key] = true
   return true
end

function M.setup()
   wezterm.on('gui-startup', function(cmd)
      local _, _, window = mux.spawn_window(cmd or {})
      first_time(window:window_id())
      window:gui_window():maximize()
   end)

   wezterm.on('update-status', function(window)
      if first_time(window:window_id()) then
         window:maximize()
      end
   end)
end

return M
