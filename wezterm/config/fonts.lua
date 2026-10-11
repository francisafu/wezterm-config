local wezterm = require('wezterm')

return {
   font = wezterm.font('Maple Mono Normal NFM CN', { weight = 'Medium' }),
   font_size = 14,
   line_height = 1.1,
   unicode_version = 14,
   allow_square_glyphs_to_overflow_width = 'Never',
   harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' },
}
