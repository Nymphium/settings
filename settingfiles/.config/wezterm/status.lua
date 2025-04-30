local wezterm = require('wezterm')

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

tabline.setup({
  sections = {
    tabline_a = { 'mode' },
    tabline_b = { 'domain' },
    tab_active = {
      ' ',
      { 'zoomed',  padding = 0 },
      -- { 'index',   padding = 0 },
      { 'process', padding = 0 },
      '|',
      { 'cwd', padding = 0 },
      ' '
    },
    tab_inactive = {
      { 'index', padding = 0 },
      'cwd',
    },
    tabline_x = {
      'ram', 'cpu'
    },
    tabline_y = { 'battery' },
    tabline_z = {}
  }
})

wezterm.on('update-status', function(_, _)
  local overrides = tabline.get_config() or {}
  local appearance = wezterm.gui.get_appearance()
  local theme
  if appearance:find 'Dark' then
    theme = wezterm.GLOBAL.theme.dark
  else
    theme = wezterm.GLOBAL.theme.light
  end
  if overrides.theme ~= theme then
    overrides.options.theme = theme
    tabline.setup(overrides)
  end
end)
