local wezterm = require('wezterm')

local commands = require('./commands')

wezterm.on('augment-command-palette', function(window, _)
  return {
    commands.list_tab(window),
    commands.list_window(window),
  }
end)
