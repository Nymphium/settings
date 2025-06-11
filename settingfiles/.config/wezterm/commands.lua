local wezterm = require('wezterm')
local act = wezterm.action

local list_tab = function(window)
  local tabs = window:mux_window():tabs()
  local choices = {}
  local max_process_len = 4 -- #"proc"
  local max_dir_len = 3     -- #"dir"
  local tab_info = {}

  for _, tab in ipairs(tabs) do
    local tab_pane = tab:active_pane()
    local pane_count = #(tab:panes())
    local title = tab:get_title()
    local process = tab_pane:get_foreground_process_name() or ''
    local cwd = tab_pane:get_current_working_dir()
    local dir_name = cwd and cwd.file_path or ''

    local process_name = process:match('([^/\\]+)$') or process

    max_process_len = math.max(max_process_len, #process_name)
    max_dir_len = math.max(max_dir_len, #dir_name)

    local table_info = {
      tab = tab,
      title = title,
      process_name = process_name,
      dir_name = dir_name,
      pane_count = pane_count,
      is_current = tab:tab_id() == window:active_tab():tab_id(),
    }
    table.insert(tab_info, table_info)
  end

  for _, info in ipairs(tab_info) do
    local process_fmt = ('%%%ds'):format(max_process_len):format(info.process_name)
    local dir_fmt = ('%%-%ds'):format(max_dir_len):format(info.dir_name)
    local pane_fmt = ('%-2d'):format(info.pane_count)
    local prefix = info.is_current and wezterm.format({
          { Foreground = { AnsiColor = 'Purple' } },
          { Text = '*' }
        })
        or ' '

    local label = {
      { Text = prefix },
      { Foreground = { AnsiColor = 'Aqua' } },
    }

    if info.title == '' then
      table.insert(label, { Text = process_fmt })
    else
      table.insert(label, { Text = info.title })
    end

    local tail = {
      'ResetAttributes',
      { Text = ' ' },
      { Text = wezterm.nerdfonts.md_drag_vertical_variant },
      { Foreground = { AnsiColor = 'Green' } },
      { Text = ' ' },
      { Text = dir_fmt },
      { Text = ' ' },
      'ResetAttributes',
      { Text = ' ' },
      { Text = wezterm.nerdfonts.md_drag_vertical_variant },
      { Text = ' ' },
      { Foreground = { AnsiColor = 'Red' } },
      { Text = pane_fmt },
    }

    for i = 1, #tail do
      table.insert(label, tail[i])
    end

    table.insert(choices, {
      id = tostring(info.tab:tab_id()),
      label = wezterm.format(label),
    })
  end

  return {
    brief = 'Tab | Activate Tab',
    doc = 'Get tab list and select',
    icon = 'md_align_horizontal_left',

    action = act.InputSelector {
      description = wezterm.format({
        { Attribute = { Intensity = 'Bold' } },
        { Text = 'Select tab to activate' },
        'ResetAttributes',
        { Text = '\n\r' },
        { Attribute = { Underline = 'Double' } },
        { Text = (' '):rep(5) },
        { Foreground = { AnsiColor = 'Aqua' } },
        { Text = ('%%%ds'):format(max_process_len):format('proc') },
        'ResetAttributes',
        { Attribute = { Underline = 'Double' } },
        { Text = ' ' },
        { Text = wezterm.nerdfonts.md_drag_vertical_variant },
        { Text = ' ' },
        { Foreground = { AnsiColor = 'Green' } },
        { Text = ('%%-%ds'):format(max_dir_len + 1):format('dir') },
        'ResetAttributes',
        { Attribute = { Underline = 'Double' } },
        { Text = ' ' },
        { Text = wezterm.nerdfonts.md_drag_vertical_variant },
        { Text = ' ' },
        { Foreground = { AnsiColor = 'Red' } },
        { Text = 'panes' }
      }),
      choices = choices,
      action = wezterm.action_callback(function(_, _, id, _)
        if id then
          for _, tab in ipairs(tabs) do
            if tostring(tab:tab_id()) == id then
              tab:activate()
              return
            end
          end
        end
      end)
    }
  }
end

local list_window = function(window)
  local mux = wezterm.mux
  local windows = mux.all_windows()
  local choices = {}

  local window_info = {}
  for _, win in ipairs(windows) do
    local tabs = win:tabs()
    local tab_count = #tabs

    local active_tab = win:active_tab()
    local active_pane = active_tab and active_tab:active_pane()

    local process = active_pane and active_pane:get_foreground_process_name() or ''
    local cwd = active_pane and active_pane:get_current_working_dir() or nil
    local dir_name = cwd and cwd.file_path or ''

    local process_name = process:match('([^/\\]+)$') or process

    table.insert(window_info, {
      window = win,
      window_id = win:window_id(),
      title = win:get_title(),
      process_name = process_name,
      dir_name = dir_name,
      tab_count = tab_count,
      is_current = win:window_id() == window:window_id()
    })
  end

  -- プロセス名とディレクトリ名の最大長を計算
  local max_process_len = 4 -- #"proc"
  local max_dir_len = 3     -- #"dir"
  for _, info in ipairs(window_info) do
    max_process_len = math.max(max_process_len, #info.process_name)
    max_dir_len = math.max(max_dir_len, #info.dir_name)
  end

  for _, info in ipairs(window_info) do
    local process_fmt = ('%%%ds'):format(max_process_len):format(info.process_name)
    local dir_fmt = ('%%-%ds'):format(max_dir_len):format(info.dir_name)
    local tab_fmt = ('%-2d'):format(info.tab_count)
    local prefix = info.is_current and wezterm.format({
          { Foreground = { AnsiColor = 'Purple' } },
          { Text = '*' }
        })
        or ' '

    local label = wezterm.format({
      { Text = prefix },
      { Foreground = { AnsiColor = 'Aqua' } },
      { Text = process_fmt },
      'ResetAttributes',
      { Text = ' ' },
      { Text = wezterm.nerdfonts.md_drag_vertical_variant },
      { Text = ' ' },
      { Foreground = { AnsiColor = 'Green' } },
      { Text = dir_fmt },
      'ResetAttributes',
      { Text = ' ' },
      { Text = wezterm.nerdfonts.md_drag_vertical_variant },
      { Text = ' ' },
      { Foreground = { AnsiColor = 'Red' } },
      { Text = tab_fmt },
    })

    table.insert(choices, {
      label = label,
      id = tostring(info.window_id),
    })
  end

  return {
    brief = 'Window | Activate Window',
    doc = 'Get window list and select',
    icon = 'md_align_horizontal_left',

    action = act.InputSelector {
      description = wezterm.format({
        { Attribute = { Intensity = 'Bold' } },
        { Text = 'Select window to activate' },
        'ResetAttributes',
        { Text = '\n\r' },
        { Attribute = { Underline = 'Double' } },
        { Text = (' '):rep(5) },
        { Foreground = { AnsiColor = 'Aqua' } },
        { Text = ('%%%ds'):format(max_process_len):format('proc') },
        'ResetAttributes',
        { Attribute = { Underline = 'Double' } },
        { Text = ' ' },
        { Text = wezterm.nerdfonts.md_drag_vertical_variant },
        { Text = ' ' },
        { Foreground = { AnsiColor = 'Green' } },
        { Text = ('%%-%ds'):format(max_dir_len):format('dir') },
        'ResetAttributes',
        { Attribute = { Underline = 'Double' } },
        { Text = ' ' },
        { Text = wezterm.nerdfonts.md_drag_vertical_variant },
        { Text = ' ' },
        { Foreground = { AnsiColor = 'Red' } },
        { Text = 'tabs' }
      }),
      choices = choices,
      action = wezterm.action_callback(function(_, _, id, _)
        if id then
          for _, info in ipairs(window_info) do
            if tostring(info.window_id) == id then
              info.window:gui_window():focus()
              return
            end
          end
        end
      end)
    }
  }
end

return {
  list_tab = list_tab,
  list_window = list_window,
}
