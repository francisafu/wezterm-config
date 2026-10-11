local wezterm = require('wezterm')
local c = require('colors.palette')

local nf = wezterm.nerdfonts

local M = {}

function M.setup()
   wezterm.on('update-status', function(window)
      local key_table = window:active_key_table()
      if not key_table then
         window:set_left_status('')
         return
      end
      window:set_left_status(wezterm.format({
         { Background = { Color = c.crust } },
         { Foreground = { Color = c.peach } },
         { Text = nf.ple_left_half_circle_thick },
         { Background = { Color = c.peach } },
         { Foreground = { Color = c.crust } },
         { Attribute = { Intensity = 'Bold' } },
         { Text = nf.md_table_key .. ' ' .. key_table:upper() },
         'ResetAttributes',
         { Background = { Color = c.crust } },
         { Foreground = { Color = c.peach } },
         { Text = nf.ple_right_half_circle_thick .. ' ' },
      }))
   end)
end

return M
