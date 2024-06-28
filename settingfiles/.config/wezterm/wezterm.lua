local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback {
  { family = 'MonaspiceAr Nerd Font' },
  { family = 'Hiragino Sans', },
  { family = 'Source Han Sans JP', },
  { family = 'Apple Color Emoji' }
}
config.colors = {
  cursor_bg = '#ffffff',
  cursor_fg = '#ffffff'
}
config.font_size = 12.5

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 1
}
config.tab_bar_at_bottom = true

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
