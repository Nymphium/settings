local wezterm = require 'wezterm'
local act = wezterm.action

local keys = {
  {
    key = 'v',
    mods = 'SHIFT|ALT',
    action = act.SplitHorizontal { domain = "CurrentPaneDomain" }
  },
  {
    key = 'w',
    mods = 'SHIFT|ALT',
    action = act.SplitVertical { domain = "CurrentPaneDomain" }
  },
  {
    key = 'l',
    mods = 'LEADER|ALT',
    action = act.AdjustPaneSize({ 'Right', 5 })
  },
  {
    key = 'g',
    mods = 'LEADER|ALT',
    action = act.SpawnCommandInNewTab {
      args = { os.getenv('TERM') },
      cwd = os.getenv('HOME')
    }
  },
  {
    key = 'd',
    mods = 'LEADER|ALT',
    action = act.CloseCurrentTab({ confirm = false })
  },
  {
    key = 'w',
    mods = 'LEADER|ALT',
    action = act.CloseCurrentPane({ confirm = false })
  },
  {
    key = 'n',
    mods = 'ALT|SHIFT',
    action = act.ActivateTabRelative(-1)
  },
  {
    key = 'n',
    mods = 'ALT',
    action = act.ActivateTabRelative(1)
  },
  {
    key = 'LeftArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection('Left')
  },
  {
    key = 'RightArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection('Right')
  },
  {
    key = 'UpArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection('Up')
  },
  {
    key = 'DownArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection('Down')
  },
  {
    key = 's',
    mods = 'LEADER|ALT',
    action = act.PaneSelect({
      mode = 'SwapWithActiveKeepFocus',
    })
  },
  {
    key = 'a',
    mods = 'LEADER|ALT',
    action = act.PaneSelect
  },
  {
    key = 'i',
    mods = 'LEADER|ALT',
    action = act.TogglePaneZoomState
  },
  {
    key = 'v',
    mods = 'SUPER',
    action = act.PasteFrom('Clipboard')
  },
  {
    key = 'Enter',
    mods = 'ALT',
    action = act.ToggleFullScreen
  },
  {
    key = 'y',
    mods = 'ALT',
    action = act.ActivateCopyMode
  },
  {
    key = ':',
    mods = 'LEADER',
    action = act.ActivateCommandPalette
  }
}

return keys
