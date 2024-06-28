local wezterm = require('wezterm')

-- The powerline < symbol
local left_arrow = utf8.char(0xe0b0)
-- The filled in variant of the >| symbol
local solid_left_arrow = utf8.char(0xe0d7)

local status_text_fg = 'white'

local basename = function(s)
  return s:gsub('(.*[/\\])(.*)', '%2')
end

wezterm.on('format-tab-title', function(tab, _, _, config, _, _)
  local elements = {}
  print(config.resolved_palette)

  if tab.is_active then
    table.insert(elements, { Background = { Color = 'none' } })
    table.insert(elements, { Foreground = { Color = config.resolved_palette.tab_bar.active_tab.bg_color } })
    table.insert(elements, { Text = solid_left_arrow })
    table.insert(elements, { Background = { Color = config.resolved_palette.tab_bar.active_tab.bg_color } })
    table.insert(elements, { Foreground = { Color = config.resolved_palette.tab_bar.active_tab.fg_color } })
  else
    table.insert(elements, { Background = { Color = config.resolved_palette.tab_bar.inactive_tab.bg_color } })
    table.insert(elements, { Foreground = { Color = config.resolved_palette.tab_bar.inactive_tab.fg_color } })
  end


  table.insert(elements, { Text = ' ' })
  table.insert(elements, { Text = tab.tab_title })
  table.insert(elements, { Text = ' ' })
  if tab.is_active then
    table.insert(elements, { Background = { Color = 'none' } })
    table.insert(elements, { Foreground = { Color = config.resolved_palette.tab_bar.active_tab.bg_color } })
    table.insert(elements, { Text = left_arrow })
  end
  return elements
end)

local format_tab = function(proc_name)
  local elements = {
    { Text = proc_name },
  }
  return wezterm.format(elements)
end


wezterm.on('update-right-status', function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  if window:leader_is_active() then
    table.insert(cells, utf8.char(0xebac))
  end

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = cwd_uri.file_path:gsub(os.getenv('HOME'), '~')
    local hostname = (cwd_uri.host or wezterm.hostname()):upper()

    table.insert(cells, hostname)
    table.insert(cells, cwd)
  end

  do
    local tab = window:active_tab()
    local proc_name = basename(pane:get_foreground_process_name())
    tab:set_title(format_tab(proc_name))
  end


  -- Color palette for the backgrounds of each cell
  local colors = {
    '#3c1361',
    '#52307c',
    '#663a82',
    '#7c5295',
    '#b491c8',
  }

  -- Foreground color for the text across the fade

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  local push = function(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = status_text_fg } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
    table.insert(elements, { Foreground = { Color = colors[cell_no] } })
    table.insert(elements, { Background = { Color = colors[cell_no + 1] } })
    if is_last then
      table.insert(elements, { Background = { Color = 'none' } })
    end

    table.insert(elements, { Text = left_arrow })

    num_cells = num_cells + 1
  end

  table.insert(elements, { Foreground = { Color = colors[1] } })
  table.insert(elements, { Text = solid_left_arrow })

  for i = 1, #cells do
    push(cells[i], i == #cells)
  end

  window:set_left_status(wezterm.format(elements))
end)
