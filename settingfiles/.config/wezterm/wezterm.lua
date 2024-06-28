local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.font_size = 14
local font = wezterm.font_with_fallback {
  { family = 'MonaspiceAr Nerd Font Mono', weight = 'Medium' },
  { family = 'Hiragino Sans', },
  { family = 'Source Han Sans JP', },
  { family = 'Apple Color Emoji' }
}
config.font = font
config.window_frame = {
  font = wezterm.font({ family = "MonaspiceAr Nerd Font Propo", weight = 'Bold' }),
  border_bottom_height = '0.3cell'
}
config.colors = {
  cursor_bg = '#ffffff',
  cursor_fg = '#ffffff'
}

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 1
}
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
-- config.tab_max_width = 100

config.leader = { key = 'b', mods = 'ALT' }
config.keys = require('./keys')

config.animation_fps = 1

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

require('./color_scheme')
require('./status')

return config
