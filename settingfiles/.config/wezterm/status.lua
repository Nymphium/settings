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

local detect_dark_mode = function()
  if not wezterm.gui then
    return
  end

  local appearance = wezterm.gui.get_appearance()
  local theme
  if appearance:find 'Dark' then
    theme = wezterm.GLOBAL.theme.dark
  else
    theme = wezterm.GLOBAL.theme.light
  end

  local overrides = tabline.get_config() or {}
  if overrides.theme ~= theme then
    overrides.options.theme = theme
    tabline.setup(overrides)
  end
end

local function timer_detect_dark_mode()
  detect_dark_mode()

  wezterm.time.call_after(3, timer_detect_dark_mode)
end

wezterm.time.call_after(0, timer_detect_dark_mode)

return {
  detect_dark_mode = detect_dark_mode,
}
