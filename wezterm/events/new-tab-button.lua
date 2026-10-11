local wezterm = require('wezterm')
local c = require('colors.palette')
local launch_menu = require('config.launch').launch_menu

local nf = wezterm.nerdfonts
local act = wezterm.action

local M = {}

local choices, spawns = {}, {}
for i, item in ipairs(launch_menu) do
   local icon, color = nf.oct_terminal, c.blue
   if item.domain then
      icon, color = nf.cod_terminal_linux, c.peach
   end
   table.insert(choices, {
      id = tostring(i),
      label = wezterm.format({
         { Foreground = { Color = color } },
         { Text = ' ' .. icon .. '  ' },
         { Foreground = { Color = c.text } },
         { Attribute = { Intensity = 'Bold' } },
         { Text = item.label },
      }),
   })
   table.insert(spawns, { args = item.args, domain = item.domain or 'DefaultDomain' })
end

local menu = act.InputSelector({
   title = '新建标签',
   choices = choices,
   fuzzy = true,
   fuzzy_description = nf.md_rocket .. ' 选择要启动的程序：',
   action = wezterm.action_callback(function(window, pane, id)
      if id then
         window:perform_action(act.SpawnCommandInNewTab(spawns[tonumber(id)]), pane)
      end
   end),
})

function M.setup()
   wezterm.on('new-tab-button-click', function(window, pane, button)
      if button == 'Left' then
         window:perform_action(menu, pane)
         return false
      end
      if button == 'Right' then
         return false
      end
   end)
end

return M
