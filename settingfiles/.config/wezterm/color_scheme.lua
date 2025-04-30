local wezterm = require('wezterm')

wezterm.GLOBAL.theme = {
  dark = 'tokyonight-storm',
  light = 'tokyonight-day'
}

wezterm.on('update-status', function(window, _)
  local overrides = window:get_config_overrides() or {}
  local appearance = wezterm.gui.get_appearance()
  local scheme
  if appearance:find 'Dark' then
    scheme = wezterm.GLOBAL.theme.dark
  else
    scheme = wezterm.GLOBAL.theme.light
  end
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
  end
end)
