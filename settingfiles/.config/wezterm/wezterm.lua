local wezterm = require("wezterm")

wezterm.GLOBAL.is_windows = wezterm.target_triple:find("windows") ~= nil

local config = wezterm.config_builder()

if wezterm.GLOBAL.is_windows then
  config.font_size = 10
  config.line_height = 1.20
  -- config.cell_width = 0.9
  config.window_background_opacity = 0.999
else
  config.front_end = "WebGpu"
  config.webgpu_power_preference = "HighPerformance"
  config.font_size = 13
end

config.command_palette_font_size = config.font_size * 1.1

config.font = wezterm.font_with_fallback({
  { family = "MonaspiceNe Nerd Font Mono" },
  { family = "Hiragino Sans" },
  { family = "Source Han Sans JP" },
  { family = "Apple Color Emoji",         assume_emoji_presentation = true },
})

-- config.treat_east_asian_ambiguous_width_as_wide = true
-- https://monaspace.githubnext.com/#code-ligatures
config.harfbuzz_features = {
  "ss01",
  "ss03",
  "ss04",
  "ss05",
  "ss06",
  "ss07",
  "ss08",
  "ss09",
  "ss10",
  "cv01=2",
  "cv02",
  "cv10",
  "cv11",
  "cv30",
  "cv31",
  "cv32",
  "cv62",
  "liga",
  "calt",
  "case",
}

config.window_frame = {
  font = wezterm.font("MonaspiceNe Nerd Font Propo", { weight = "Bold" }),
  border_bottom_height = "0.3cell",
}

config.window_content_alignment = {
  horizontal = "Center",
  vertical = "Center",
}

config.window_padding = {
  left = -6,
  right = -6,
  top = -15,
  bottom = -5,
}

config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_max_width = 40
config.disable_default_key_bindings = true
config.max_fps = 144

config.scrollback_lines = 1000
config.animation_fps = 1

local keys = require("./keys")

config.leader = keys.leader
config.keys = keys.keys
config.key_tables = keys.key_tables

require("./color_scheme")
require("./command_palette")
require("./status")

config.ssh_domains = config.ssh_domains or {}
for host, ssh_option in pairs(wezterm.enumerate_ssh_hosts()) do
  table.insert(config.ssh_domains, {
    name = host,
    remote_address = ssh_option.hostname,
    ssh_option = ssh_option,
  })
end

return config
