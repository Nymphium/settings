local wezterm = require('wezterm')

wezterm.GLOBAL.is_windows = wezterm.target_triple:find('windows') ~= nil

local config = wezterm.config_builder()

if wezterm.GLOBAL.is_windows then
  config.font_size = 10
else
  config.font_size = 13
end

config.font = wezterm.font_with_fallback {
  { family = 'MonaspiceNe Nerd Font Mono' },
  { family = 'Hiragino Sans', },
  { family = 'Source Han Sans JP', },
  { family = 'Apple Color Emoji',         assume_emoji_presentation = true }
}

-- config.treat_east_asian_ambiguous_width_as_wide = true
-- https://monaspace.githubnext.com/#code-ligatures
config.harfbuzz_features = { 'ss01', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'ss10', 'cv01=2', 'cv02',
  'cv10', 'cv11', 'cv30', 'cv31', 'cv32', 'cv62', 'liga', 'calt', 'case' }

config.window_frame = {
  font = wezterm.font('MonaspiceNe Nerd Font Propo', { weight = 'Bold' }),
  border_bottom_height = '0.3cell'
}

config.window_content_alignment = {
  horizontal = 'Center',
  vertical = 'Center',
}

config.window_padding = {
  left = -6,
  right = -6,
  top = -15,
  bottom = -5
}

-- config.mux_enable_ssh_agent = true
-- config.mux_output_parser_coalesce_delay_ms = 1
-- config.mux_output_parser_buffer_size = 8192

config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_max_width = 40
config.disable_default_key_bindings = true
config.animation_fps = 1

-- wezterm.on('gui-startup', function(cmd)
--   local _, _, window = wezterm.mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)
--
local keys = require('./keys')

config.leader = keys.leader
config.keys = keys.keys
config.key_tables = keys.key_tables
--
require('./color_scheme')
require('./command_palette')
require('./status')
-- require('./plugins')

local ok, ssh_domains = pcall(require, './ssh_domains')
if ok then
  config.ssh_domains = ssh_domains
end

return config
