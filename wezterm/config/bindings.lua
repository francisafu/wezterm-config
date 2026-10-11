local wezterm = require('wezterm')
local act = wezterm.action

local CS = 'CTRL|SHIFT'

local rename_tab = act.PromptInputLine({
   description = wezterm.format({
      { Attribute = { Intensity = 'Bold' } },
      { Text = '输入标签名（留空回车恢复自动名，Esc 取消）' },
   }),
   action = wezterm.action_callback(function(window, _pane, line)
      if line ~= nil then
         window:active_tab():set_title(line)
      end
   end),
})

local open_url = act.QuickSelectArgs({
   label = 'open url',
   patterns = {
      '\\((https?://\\S+)\\)',
      '\\[(https?://\\S+)\\]',
      '\\{(https?://\\S+)\\}',
      '<(https?://\\S+)>',
      '\\bhttps?://\\S+[)/a-zA-Z0-9-]+',
   },
   action = wezterm.action_callback(function(window, pane)
      wezterm.open_with(window:get_selection_text_for_pane(pane))
   end),
})

local keys = {
   { key = 'phys:M', mods = CS, action = act.ActivateCommandPalette },
   { key = 'phys:Y', mods = CS, action = act.ShowTabNavigator },

   { key = 'phys:C', mods = CS, action = act.CopyTo('Clipboard') },
   { key = 'phys:V', mods = CS, action = act.PasteFrom('Clipboard') },
   { key = 'phys:S', mods = CS, action = act.Search({ CaseInSensitiveString = '' }) },
   { key = 'phys:U', mods = CS, action = open_url },

   { key = 'phys:T', mods = CS, action = act.SpawnTab('DefaultDomain') },
   { key = 'phys:B', mods = CS, action = act.SpawnTab({ DomainName = 'WSL:Ubuntu' }) },
   { key = 'phys:Q', mods = CS, action = act.CloseCurrentTab({ confirm = true }) },
   { key = 'phys:LeftBracket', mods = CS, action = act.ActivateTabRelative(-1) },
   { key = 'phys:RightBracket', mods = CS, action = act.ActivateTabRelative(1) },
   { key = 'phys:Comma', mods = CS, action = act.MoveTabRelative(-1) },
   { key = 'phys:Period', mods = CS, action = act.MoveTabRelative(1) },
   { key = 'phys:R', mods = CS, action = rename_tab },

   { key = 'phys:Backslash', mods = CS, action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
   { key = 'phys:Slash', mods = CS, action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
   { key = 'phys:Z', mods = CS, action = act.TogglePaneZoomState },
   { key = 'phys:A', mods = CS, action = act.CloseCurrentPane({ confirm = true }) },
   { key = 'phys:I', mods = CS, action = act.ActivatePaneDirection('Up') },
   { key = 'phys:K', mods = CS, action = act.ActivatePaneDirection('Down') },
   { key = 'phys:J', mods = CS, action = act.ActivatePaneDirection('Left') },
   { key = 'phys:L', mods = CS, action = act.ActivatePaneDirection('Right') },
   { key = 'phys:G', mods = CS, action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }) },

   { key = 'UpArrow', mods = CS, action = act.IncreaseFontSize },
   { key = 'DownArrow', mods = CS, action = act.DecreaseFontSize },
   { key = 'phys:Equal', mods = CS, action = act.ResetFontSize },

   { key = 'PageUp', mods = CS, action = act.ScrollByPage(-0.6) },
   { key = 'PageDown', mods = CS, action = act.ScrollByPage(0.6) },
   { key = 'Home', mods = CS, action = act.ScrollToTop },
   { key = 'End', mods = CS, action = act.ScrollToBottom },
}

for i = 1, 9 do
   table.insert(keys, { key = 'phys:' .. i, mods = CS, action = act.ActivateTab(i - 1) })
end

return {
   disable_default_key_bindings = true,
   keys = keys,
   mouse_bindings = {
      {
         event = { Up = { streak = 1, button = 'Left' } },
         mods = 'CTRL',
         action = act.OpenLinkAtMouseCursor,
      },
      {
         event = { Down = { streak = 1, button = 'Left' } },
         mods = 'CTRL',
         action = act.Nop,
      },
   },
}
