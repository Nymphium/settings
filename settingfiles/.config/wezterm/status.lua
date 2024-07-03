local wezterm = require('wezterm')

-- The powerline < symbol
local right_arrow = utf8.char(0xe0b0)
-- The filled in variant of the >| symbol
local solid_right_arrow = utf8.char(0xe0d7)

local status_text_fg = 'white'
local home = (os.getenv('HOME') or os.getenv('USERPROFILE') or wezterm.home_dir or ""):gsub('\\', '/')

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

wezterm.on('format-tab-title', function(tab, _, _, config, _, _)
  local muxtab = wezterm.mux.get_tab(tab.tab_id)
  local panes = muxtab:panes_with_info()

  local cwd = ''
  do
    local cwd_uri = muxtab:active_pane():get_current_working_dir()
    if cwd_uri then
      cwd = wezterm.truncate_right(basename(cwd_uri.file_path), 15)
    end
  end

  local title = wezterm.truncate_right(tab.tab_title, 15)

  local text = (' %d) %s┃%s '):format(#panes, title, cwd)

  local symbol_fg, text_fg, text_bg

  if tab.is_active and config.resolved_palette.tab_bar then
    symbol_fg = config.resolved_palette.tab_bar.active_tab.bg_color
    text_fg = config.resolved_palette.tab_bar.active_tab.fg_color
    text_bg = config.resolved_palette.tab_bar.active_tab.bg_color
  else
    symbol_fg = config.resolved_palette.tab_bar.inactive_tab.bg_color
    text_fg = config.resolved_palette.tab_bar.inactive_tab.fg_color
    text_bg = config.resolved_palette.tab_bar.inactive_tab.bg_color
  end

  return {
    { Background = { Color = 'none' } },
    { Foreground = { Color = symbol_fg } },
    { Text = solid_right_arrow },

    { Background = { Color = text_bg } },
    { Foreground = { Color = text_fg } },
    { Text = text },

    { Background = { Color = 'none' } },
    { Foreground = { Color = symbol_fg } },
    { Text = right_arrow },
  }
end)

wezterm.on('update-right-status', function(window, pane)
  local cells = {}

  if window:leader_is_active() then
    table.insert(cells, utf8.char(0xebac))
  end

  table.insert(cells, (wezterm:hostname()):upper())

  do
    local tab = window:active_tab()
    local proc_name = basename(pane:get_foreground_process_name())
    tab:set_title(proc_name)
  end

  if not wezterm.GLOBAL.is_windows then
    local usage, max, max_proc = get_mem()
    table.insert(cells, ('MEM %.1f%%┃%s(%.1f%%)'):format(usage, wezterm.truncate_right(basename(max_proc), 10), max))

    usage, max, max_proc = get_cpu()
    table.insert(cells, ('CPU %.1f%%┃%s(%.1f%%)'):format(usage, wezterm.truncate_right(basename(max_proc), 10), max))
  end

  -- Color palette for the backgrounds of each cell
  local colors = {
    '#3c1361',
    '#52307c',
    '#663a82',
    '#7c5295',
    '#b491c8',
  }

  local elements = {
    { Background = { Color = 'none' } },
    { Text = ' ' },
  }

  for i = 1, #cells do
    local symbol_bg = colors[i % #colors + 1]

    table.insert(elements, { Foreground = { Color = symbol_bg } })
    table.insert(elements, { Text = solid_right_arrow })

    table.insert(elements, { Background = { Color = symbol_bg } })
    table.insert(elements, { Foreground = { Color = status_text_fg } })
    table.insert(elements, { Text = ' ' .. cells[i] .. ' ' })

    if i == #cells then
      table.insert(elements, { Background = { Color = 'none' } })
      table.insert(elements, { Foreground = { Color = symbol_bg } })
      table.insert(elements, { Text = right_arrow })
    end
  end

  window:set_left_status(wezterm.format(elements))
end)
