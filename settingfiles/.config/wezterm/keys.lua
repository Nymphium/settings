local wezterm = require 'wezterm'
local act = wezterm.action

local panemove = {
  left = {
    key = 'LeftArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection('Left')
  },
  right = {
    key = 'RightArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection('Right')
  },
  up = {
    key = 'UpArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection('Up')
  },
  down = {
    key = 'DownArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection('Down')
  }
}

local paneadjust = {
  left = {
    key = 'h',
    mods = 'LEADER|ALT',
    action = act.AdjustPaneSize({ 'Left', 5 })
  },
  right = {
    key = 'j',
    mods = 'LEADER|ALT',
    action = act.AdjustPaneSize({ 'Down', 5 })
  },
  up = {
    key = 'k',
    mods = 'LEADER|ALT',
    action = act.AdjustPaneSize({ 'Up', 5 })
  },
  down = {
    key = 'l',
    mods = 'LEADER|ALT',
    action = act.AdjustPaneSize({ 'Right', 5 })
  },
}

local keys = {
  leader = { key = 'b', mods = 'ALT' },
  keys = {
    {
      key = '.',
      mods = 'SUPER',
      action = act.CharSelect,
    },
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
    paneadjust.left,
    paneadjust.right,
    paneadjust.up,
    paneadjust.down,
    panemove.left,
    panemove.right,
    panemove.up,
    panemove.down,
    {
      key = 'g',
      mods = 'LEADER|ALT',
      action = wezterm.action_callback(function(win, _)
        return win:mux_window():spawn_tab { cwd = wezterm.home_dir }
      end),
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
      key = 't',
      mods = 'ALT',
      action = act.RotatePanes 'CounterClockwise'
    },
    {
      key = 't',
      mods = 'ALT|SHIFT',
      action = act.RotatePanes 'Clockwise'
    },
    {
      key = 'i',
      mods = 'LEADER|ALT',
      action = act.TogglePaneZoomState
    },
    {
      key = 'p',
      mods = 'LEADER',
      action = act.PasteFrom('Clipboard')
    },
    {
      key = 'Enter',
      mods = 'ALT',
      action = act.ToggleFullScreen
    },
    {
      key = ':',
      mods = 'LEADER',
      action = act.ActivateCommandPalette
    },
    {
      key = '=',
      mods = 'ALT|SHIFT',
      action = act.IncreaseFontSize,
    },
    {
      key = '0',
      mods = 'ALT',
      action = act.ResetFontSize,
    },
    {
      key = '-',
      mods = 'ALT',
      action = act.DecreaseFontSize,
    },
    {
      key = '/',
      mods = 'LEADER',
      action = act.Search 'CurrentSelectionOrEmptyString',
    },
    {
      key = 'y',
      mods = 'ALT',
      action = wezterm.action_callback(function(win, pane)
        win:perform_action(act.ActivateCopyMode, pane)
        win:perform_action(act.CopyMode 'ClearPattern', pane)
        win:perform_action(act.CopyMode 'ClearSelectionMode', pane)
        win:perform_action(act.ScrollToPrompt(1), pane)
        -- win:perform_action(act.ActivateCopyMode, pane)
      end)
    }
  },
  key_tables = {
    copy_mode = {
      paneadjust.left,
      paneadjust.right,
      paneadjust.up,
      paneadjust.down,

      {
        key = 'e',
        action = act.CopyMode 'MoveForwardWord',
      }, {
      key = 'b',
      action = act.CopyMode 'MoveBackwardWord',
    },
      {
        key = 'i',
        action = act.Multiple {
          { CopyMode = 'ClearSelectionMode' },
          { CopyMode = 'Close' },
          act.ScrollToBottom,
        }
      },
      {
        key = 'a',
        action = act.Multiple {
          { CopyMode = 'ClearSelectionMode' },
          { CopyMode = 'Close' },
          act.ScrollToBottom,
        }
      },
      {
        key = '/',
        action = act.CopyMode 'EditPattern'
      },

      {
        key = 'g',
        mods = 'SHIFT',
        action = act.ScrollToBottom,
      },
      {
        key = 'h',
        mods = 'NONE',
        action = act.Multiple {
          -- act.ClearSelection,
          { CopyMode = 'MoveLeft' },
        }
      },
      {
        key = 'l',
        mods = 'NONE',
        action = act.Multiple {
          -- act.ClearSelection,
          { CopyMode = 'MoveRight' },
        }
      },
      {
        key = 'k',
        mods = 'NONE',
        action = act.Multiple {
          -- act.ClearSelection,
          { CopyMode = 'MoveUp' },
        }
      },
      {
        key = 'j',
        mods = 'NONE',
        action = act.Multiple {
          -- act.ClearSelection,
          { CopyMode = 'MoveDown' },
        }
      },
      {
        key = '$',
        mods = 'NONE',
        action = act.CopyMode 'MoveToEndOfLineContent',
      },
      {
        key = '^',
        mods = 'NONE',
        action = act.CopyMode 'MoveToStartOfLineContent',
      },
      {
        key = 'PageUp',
        mods = 'NONE',
        action = act.CopyMode 'PageUp',
      },
      {
        key = 'PageDown',
        mods = 'NONE',
        action = act.CopyMode 'PageDown',
      },

      {
        key = 'Enter',
        action = act.Multiple {
          act.CopyMode 'NextMatch',
          { CopyMode = 'ClearSelectionMode' },
        }
      },
      {
        key = 'Enter',
        mods = 'SHIFT',
        action = act.Multiple {
          act.CopyMode 'PriorMatch',
          { CopyMode = 'ClearSelectionMode' },
        }
      },
      {
        key = 'Escape',
        action = act.Multiple {
          { CopyMode = 'ClearSelectionMode' },
        }
      },
      {
        key = 'v',
        mods = 'SHIFT',
        action = act.CopyMode { SetSelectionMode = 'Block' }
      },
      {
        key = 'v',
        action = act.Multiple {
          act.CopyMode { SetSelectionMode = 'Cell' },
        }
      },
      {
        key = 'y',
        action = act.Multiple {
          act.CopyTo 'PrimarySelection',
          { CopyMode = 'ClearSelectionMode' },
          { CopyMode = 'Close' },
          act.ScrollToBottom,
        }
      },
    },
    search_mode = {
      {
        key = 'Enter',
        action = act.CopyMode 'AcceptPattern'
      }
    }
  }
}

return keys
