local wezterm = require('wezterm')

local color_schemes = {
  dark = 'tokyonight-storm',
  light = 'tokyonight-day'
}

wezterm.on('update-status', function(window, _)
  local overrides = window:get_config_overrides() or {}
  local appearance = wezterm.gui.get_appearance()
  local scheme
  if appearance:find 'Dark' then
    scheme = color_schemes.dark
  else
    scheme = color_schemes.light
  end
  if overrides.color_scheme ~= scheme then
    wezterm.GLOBAL.scheme = scheme
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
  end
end)
