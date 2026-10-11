local wezterm = require('wezterm')
local c = require('colors.palette')

local nf = wezterm.nerdfonts

local function title_button(icon, hover_bg, hover_fg)
   return ' ' .. icon .. ' ',
      wezterm.format({
         { Background = { Color = hover_bg } },
         { Foreground = { Color = hover_fg } },
         { Text = ' ' .. icon .. ' ' },
      })
end

local min, min_hover = title_button(nf.cod_chrome_minimize, c.surface1, c.text)
local max, max_hover = title_button(nf.cod_chrome_maximize, c.surface1, c.text)
local close, close_hover = title_button(nf.cod_chrome_close, c.red, c.crust)

return {
   front_end = 'OpenGL',
   animation_fps = 60,
   underline_thickness = '1.5pt',

   command_palette_fg_color = c.lavender,
   command_palette_bg_color = c.crust,
   command_palette_font_size = 12,
   command_palette_rows = 25,

   default_cursor_style = 'BlinkingBar',
   color_scheme = 'Catppuccin Mocha',

   window_background_opacity = 0.85,
   win32_system_backdrop = 'Acrylic',

   enable_scroll_bar = true,
   min_scroll_bar_height = '3cell',

   use_fancy_tab_bar = false,
   tab_max_width = 25,
   switch_to_last_active_tab_when_closing_tab = true,

   window_decorations = 'INTEGRATED_BUTTONS|RESIZE',
   tab_bar_style = {
      window_hide = min,
      window_hide_hover = min_hover,
      window_maximize = max,
      window_maximize_hover = max_hover,
      window_close = close,
      window_close_hover = close_hover,
   },
   window_padding = {
      left = 10,
      right = '1cell',
      top = 10,
      bottom = 10,
   },
   adjust_window_size_when_changing_font_size = false,

   inactive_pane_hsb = { saturation = 0.9, brightness = 0.5 },
}
