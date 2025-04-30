local wezterm = require('wezterm')

wezterm.GLOBAL.is_windows = wezterm.target_triple:find('windows') ~= nil

local config = wezterm.config_builder()

config.font_size = 12

local font = wezterm.font_with_fallback {
  { family = 'MonaspiceAr Nerd Font Mono', weight = 'Medium' },
  { family = 'Hiragino Sans', },
  { family = 'Source Han Sans JP', },
  { family = 'Apple Color Emoji' }
}

config.font = font

config.window_frame = {
  font = wezterm.font('MonaspiceAr Nerd Font Propo', { weight = 'Bold' }),
  border_bottom_height = '0.3cell'
}

config.window_padding = {
  left = 12,
  right = 12,
  top = 0,
  bottom = 0
}

config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_max_width = 40
config.disable_default_key_bindings = true
config.animation_fps = 1

wezterm.on('gui-startup', function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

local keys = require('./keys')

config.leader = keys.leader
config.keys = keys.keys
config.key_tables = keys.key_tables

require('./color_scheme')
require('./commands')
require('./status')
require('./plugins')

return config
