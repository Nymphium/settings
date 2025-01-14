local wezterm = require('wezterm')

local sep_right = wezterm.nerdfonts.pl_left_hard_divider
-- local sep_left = wezterm.nerdfonts.pl_left_hard_divider_inverse
local sep_left = utf8.char(0xe0d7)

local status_text_fg = 'white'
local home = (os.getenv('HOME')
  or os.getenv('USERPROFILE')
  or wezterm.home_dir or ""):gsub('\\', '/')

local basename = function(s)
  if not s then
    return ''
  end

  if s == home then
    return '~'
  end


  return s:gsub('(.*[/\\])(.*)', '%2')
end

local get_mem = function()
  local success, stdout, stderr = wezterm.run_child_process { 'ps', '-A', '-o', '%mem comm' }
  if not success then
    wezterm.log_error(stderr)
    return
  end

  local max = 0
  local max_proc = ''
  local usage = 0

  -- aggregate memory usage
  for line in stdout:gmatch('[^\n]+') do
    local mem, proc = line:match('^%s*(%d+%.%d+)%s+(.*)$')
    if mem and proc then
      mem = tonumber(mem)
      usage = usage + mem

      if mem > max then
        ---@diagnostic disable-next-line: cast-local-type
        max = mem
        max_proc = proc
      end
    end
  end

  return usage, max, max_proc
end

local get_cpu = function()
  local success, stdout, stderr = wezterm.run_child_process { 'ps', '-A', '-o', '%cpu comm' }
  if not success then
    wezterm.log_error(stderr)
    return
  end

  local max = 0
  local max_proc = ''
  local usage = 0

  -- aggregate memory usage
  for line in stdout:gmatch('[^\n]+') do
    local cpu, proc = line:match('^%s*(%d+%.%d+)%s+(.*)$')
    if cpu and proc then
      cpu = tonumber(cpu)
      usage = usage + cpu

      if cpu > max then
        ---@diagnostic disable-next-line: cast-local-type
        max = cpu
        max_proc = proc
      end
    end
  end

  return usage, max, max_proc
end

wezterm.on('format-tab-title', function(tab, _, _, config, _, max_width)
  if not config.resolved_palette.tab_bar then
    return
  end

  local muxtab = wezterm.mux.get_tab(tab.tab_id)
  local panes = muxtab:panes_with_info()

  local text = (' %%%s'):format(#panes)
  local next_sep = ') '

  local title = wezterm.truncate_right(tab.tab_title, max_width // 2)
  if title and #title > 0 then
    text = ('%s%s%s'):format(text, next_sep, title)
    next_sep = '┃'
  end

  local symbol_fg, text_fg, text_bg

  if tab.is_active then
    symbol_fg = config.resolved_palette.tab_bar.active_tab.bg_color
    text_fg = config.resolved_palette.tab_bar.active_tab.fg_color
    text_bg = config.resolved_palette.tab_bar.active_tab.bg_color

    local active_pane = muxtab:active_pane()
    local ok, cwd_uri, err = pcall(active_pane.get_current_working_dir, active_pane)
    if not ok then
      wezterm.log_error(cwd_uri, err)
      return
    end

    if cwd_uri then
      local cwd = wezterm.truncate_right(basename(cwd_uri.file_path), max_width // 2)
      text = ('%s%s%s'):format(text, next_sep, cwd)
    end
  else
    symbol_fg = config.resolved_palette.tab_bar.inactive_tab.bg_color
    text_fg = config.resolved_palette.tab_bar.inactive_tab.fg_color
    text_bg = config.resolved_palette.tab_bar.inactive_tab.bg_color
  end

  text = wezterm.truncate_right(text .. ' ', max_width)

  return {
    { Background = { Color = 'none' } },
    { Foreground = { Color = symbol_fg } },
    { Text = sep_left },

    { Background = { Color = text_bg } },
    { Foreground = { Color = text_fg } },
    { Text = text },

    { Background = { Color = 'none' } },
    { Foreground = { Color = symbol_fg } },
    { Text = sep_right },

    { Foreground = { Color = 'none' } },
  }
end)

wezterm.on('update-status', function(window, pane)
  local right_cells = {}
  local left_cells = {}
  local tab = window:active_tab()

  if window:leader_is_active() then
    table.insert(left_cells, utf8.char(0xebac))
  end

  for _, p in pairs(tab:panes_with_info()) do
    if p.is_active and p.is_zoomed then
      table.insert(left_cells, wezterm.nerdfonts.fa_arrows_alt)
    end
  end

  table.insert(right_cells, wezterm:hostname():upper())

  do
    local ok, proc_name, err = pcall(pane.get_foreground_process_name, pane)
    if not ok then
      wezterm.log_error(err)
      return
    end

    tab:set_title(basename(proc_name))
  end

  if not wezterm.GLOBAL.is_windows then
    local usage, max, max_proc = get_mem()
    table.insert(right_cells,
      ('MEM %.1f%%│%s(%.1f%%)'):format(usage, wezterm.truncate_right(basename(max_proc), 10), max))

    usage, max, max_proc = get_cpu()
    table.insert(right_cells,
      ('CPU %.1f%%│%s(%.1f%%)'):format(usage, wezterm.truncate_right(basename(max_proc), 10), max))
  end

  -- Color palette for the backgrounds of each cell
  local colors = {
    '#3c1361',
    '#52307c',
    '#663a82',
    '#7c5295',
    '#b491c8',
  }

  local right_status = {
    { Background = { Color = 'none' } },
  }

  for i = 1, #right_cells do
    local symbol_bg = colors[i % #colors + 1]

    table.insert(right_status, { Foreground = { Color = symbol_bg } })
    table.insert(right_status, { Text = sep_left })

    table.insert(right_status, { Background = { Color = symbol_bg } })
    table.insert(right_status, { Foreground = { Color = status_text_fg } })
    table.insert(right_status, { Text = ' ' .. right_cells[i] .. ' ' })


    table.insert(right_status, { Background = { Color = 'none' } })
    table.insert(right_status, { Foreground = { Color = symbol_bg } })
    table.insert(right_status, { Text = sep_right })
  end

  local left_status = {
    { Background = { Color = 'none' } },
    { Text = ' ' },
  }

  for i = 1, #left_cells do
    local symbol_bg = colors[i % #colors + 1]

    table.insert(left_status, { Foreground = { Color = symbol_bg } })
    table.insert(left_status, { Text = sep_left })

    table.insert(left_status, { Background = { Color = symbol_bg } })
    table.insert(left_status, { Foreground = { Color = status_text_fg } })
    table.insert(left_status, { Text = ' ' .. left_cells[i] .. ' ' })

    if i == #left_cells then
      table.insert(left_status, { Background = { Color = 'none' } })
      table.insert(left_status, { Foreground = { Color = symbol_bg } })
      table.insert(left_status, { Text = sep_right })
    end
  end

  window:set_left_status(wezterm.format(left_status))
  window:set_right_status(wezterm.format(right_status))
end)
