local wezterm = require('wezterm')

wezterm.GLOBAL.is_windows = wezterm.target_triple:find('windows') ~= nil

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
  font = wezterm.font("MonaspiceAr Nerd Font Propo", { weight = 'Bold' }),
  border_bottom_height = '0.3cell'
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
config.tab_max_width = 40

config.leader = { key = 'b', mods = 'ALT' }
config.disable_default_key_bindings = true
config.disable_default_mouse_bindings = true
config.keys = require('./keys')

config.animation_fps = 1

wezterm.on('gui-startup', function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

require('./color_scheme')
require('./status')

return config
