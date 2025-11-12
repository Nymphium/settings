local wezterm = require('wezterm')
local act = wezterm.action

local proc_label = 'proc'
local dir_label = 'dir'
local preview_label = ' Preview '

local preview_poll = '┃ '
local preview_corners = {
  horizontal = '━',
  top = { left = '┏', right = '┓' },
  bottom = { left = '┗', right = '┛' },
}

local list_tab = function(window)
  local tabs = window:mux_window():tabs()
  local choices = {}
  local max_proc_len = #proc_label
  local max_dir_len = #dir_label
  local tab_info = {}

  for _, tab in ipairs(tabs) do
    local tab_pane = tab:active_pane()
    local pane_count = #(tab:panes())
    local title = tab:get_title()
    local process = tab_pane:get_foreground_process_name() or ''
    local cwd = tab_pane:get_current_working_dir()
    local dir_name = cwd and cwd.file_path or ''

    local process_name = process:match('([^/\\]+)$') or process

    max_proc_len = math.max(max_proc_len, #process_name)
    max_dir_len = math.max(max_dir_len, #dir_name)

    table.insert(tab_info, {
      tab = tab,
      title = title,
      process_name = process_name,
      dir_name = dir_name,
      pane_count = pane_count,
      is_current = tab:tab_id() == window:active_tab():tab_id(),
    })
  end

  for _, info in ipairs(tab_info) do
    local process_fmt = ('%%%ds'):format(max_proc_len):format(info.process_name)
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

    for _, t in ipairs(tail) do
      table.insert(label, t)
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
      title = 'Tab | Activate Tab',
      description = wezterm.format({
        { Attribute = { Intensity = 'Bold' } },
        { Text = 'Select tab to activate' },
        'ResetAttributes',
        { Text = '\n\r' },
        { Attribute = { Underline = 'Double' } },
        { Text = (' '):rep(5) },
        { Foreground = { AnsiColor = 'Aqua' } },
        { Text = ('%%%ds'):format(max_proc_len):format(proc_label) },
        'ResetAttributes',
        { Attribute = { Underline = 'Double' } },
        { Text = ' ' },
        { Text = wezterm.nerdfonts.md_drag_vertical_variant },
        { Text = ' ' },
        { Foreground = { AnsiColor = 'Green' } },
        { Text = ('%%-%ds'):format(math.min(max_dir_len + 1, 99)):format(dir_label) },
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

  local windows_info = {}
  for _, win in ipairs(windows) do
    local ws = win:get_workspace()
    local tabs = win:tabs()
    local tab_count = #tabs

    local active_tab = win:active_tab()
    local active_pane = active_tab and active_tab:active_pane()

    local process = active_pane and active_pane:get_foreground_process_name() or ''
    local cwd = active_pane and active_pane:get_current_working_dir() or nil
    local dir_name = cwd and cwd.file_path or ''

    local process_name = process:match('([^/\\]+)$') or process

    table.insert(windows_info, {
      active_pane = active_pane,
      window = win,
      workspace = ws,
      window_id = win:window_id(),
      title = win:get_title(),
      process_name = process_name,
      dir_name = dir_name,
      tab_count = tab_count,
      is_current = win:window_id() == window:window_id()
    })
  end

  local max_process_len = #proc_label
  local max_dir_len = #dir_label
  local title_na = '(n/a)'
  local max_name_len = #title_na -- #"(n/a)"
  for _, info in ipairs(windows_info) do
    max_process_len = math.max(max_process_len, #info.process_name)
    max_dir_len = math.max(max_dir_len, #info.dir_name)
    max_name_len = math.max(max_name_len, #info.title or 0)
  end

  for _, info in ipairs(windows_info) do
    local process_fmt = ('%%%ds'):format(max_process_len):format(info.process_name)
    local name_fmt
    local title = title_na
    if #info.title > 0 then
      title = info.title
    end
    local title_len = #title
    local diff = max_name_len - title_len
    if diff <= 0 then
      name_fmt = title
    else
      local mid_name_len = math.floor(diff / 2)
      local name_len_mantissa = diff % 2
      name_fmt = ('%s%s%s'):format((' '):rep(mid_name_len), title, (' '):rep(mid_name_len + name_len_mantissa))
    end
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
      { Foreground = { AnsiColor = 'Green' } },
      { Text = name_fmt },
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

  local title = 'Window | Activate Window'
  local description = wezterm.format({
    { Attribute = { Intensity = 'Bold' } },
    { Text = 'Select window to activate' },
    'ResetAttributes',
    { Text = '\n\r' },
    { Attribute = { Underline = 'Double' } },
    { Text = (' '):rep(5) },
    { Foreground = { AnsiColor = 'Aqua' } },
    { Text = ('%%%ds'):format(max_process_len):format(proc_label) },
    'ResetAttributes',
    { Attribute = { Underline = 'Double' } },
    { Text = ' ' },
    { Text = wezterm.nerdfonts.md_drag_vertical_variant },
    { Text = ' ' },
    { Foreground = { AnsiColor = 'Green' } },
    { Text = ('%%-%ds'):format(max_dir_len):format(dir_label) },
    'ResetAttributes',
    { Attribute = { Underline = 'Double' } },
    { Text = ' ' },
    { Text = wezterm.nerdfonts.md_drag_vertical_variant },
    { Text = ' ' },
    { Foreground = { AnsiColor = 'Green' } },
    { Text = ('%%%ds'):format(math.min(max_name_len, 99)):format('name') },
    'ResetAttributes',
    { Attribute = { Underline = 'Double' } },
    { Text = ' ' },
    { Text = wezterm.nerdfonts.md_drag_vertical_variant },
    { Text = ' ' },
    { Foreground = { AnsiColor = 'Red' } },
    { Text = 'tabs' }
  })

  local action
  action = act.InputSelector {
    title = title,
    description = description,
    choices = choices,
    action = wezterm.action_callback(function(win, pane, id, _)
      if not id then return end -- ignore such as error window

      local preview_poll_width = wezterm.column_width(preview_poll:rep(2))

      local info
      for _, i in ipairs(windows_info) do
        if tostring(i.window_id) == id then
          info = i
          break
        end
      end

      local p = info.active_pane
      local dims = p:get_dimensions()

      local max_line_width = math.max(dims.cols - preview_poll_width, 20)

      local all_lines = p:get_lines_as_escapes(dims.viewport_rows)
      local ls = {}
      for _, l in ipairs(wezterm.split_by_newlines(all_lines)) do
        table.insert(ls, l)
      end

      local fmt = { 'ResetAttributes',
        { Foreground = { Color = 'red' } },
        { Text = preview_corners.top.left },
        'ResetAttributes',
        { Background = { Color = 'red' } },
        { Foreground = { Color = 'white' } },
        { Text = preview_label },
        'ResetAttributes',
        { Foreground = { Color = 'red' } },
      }

      local width_left = dims.cols -
          wezterm.column_width(preview_corners.top.left .. preview_corners.top.right .. preview_label) - 1

      table.insert(fmt, { Text = (preview_corners.horizontal):rep(width_left) .. preview_corners.top.right })

      -- preview up to 80% view lines
      for i = 1, math.min(math.floor(dims.viewport_rows * 0.8), #ls) do
        local ln = ls[i]

        local orig_width = wezterm.column_width(ln)
        -- strip ANSI escape sequences
        local plain_width = wezterm.column_width(ln:gsub('%c%[[0-9:]+;?[0-9]*[A-T]?f?m?', ''))
        local txt = wezterm.truncate_right(wezterm.pad_right(ln, max_line_width + orig_width - plain_width),
          max_line_width + orig_width - plain_width)

        local linefmt = {
          'ResetAttributes',
          { Foreground = { Color = 'red' } },
          { Text = '\n\r ' },
          'ResetAttributes',
          { Text = txt },
          'ResetAttributes',
        }
        table.move(linefmt, 1, #linefmt, #fmt + 1, fmt)
      end
      local endfmt = {
        'ResetAttributes',
        { Text = '\n\r' },
        { Foreground = { Color = 'red' } },
        {
          Text = ('%s%s%s\n\r'):format(
            preview_corners.bottom.left,
            (preview_corners.horizontal):rep(dims.cols -
              wezterm.column_width(preview_corners.bottom.left .. preview_corners.bottom.right)
              - 1),
            preview_corners.bottom.right)
        },
        'ResetAttributes',
      }
      table.move(endfmt, 1, #endfmt, #fmt + 1, fmt)

      local ok, preview = pcall(wezterm.format, fmt)
      if not ok then
        wezterm.log_error('Error formatting preview: ' .. tostring(preview))
        preview = wezterm.format({
          { Text = 'no preview' }
        })
      end

      win:perform_action(act.PromptInputLine {
        prompt = preview,
        initial_value = '',
        action = wezterm.action_callback(function(_, _, line)
          if not line then
            -- go back selection
            window:perform_action(action, pane)
          else
            ---@diagnostic disable-next-line: redefined-local
            local ok, err = pcall(function()
              info.window:gui_window():focus()
            end)
            if not ok then
              if type(err) == 'userdata' and tostring(err):match('is not currently associated with a gui window') then
                mux.set_active_workspace(info.workspace)
                wezterm.time.call_after(0.1, wezterm.reload_configuration)
              else
                wezterm.log_info('Error activating window: ' .. tostring(err), type(err))
                return
              end
            end
          end
        end),
      }, pane)
    end)
  }

  return {
    brief = title,
    doc = 'Get window list and select',
    icon = 'md_align_horizontal_left',
    action = action,
  }
end

return {
  list_tab = list_tab,
  list_window = list_window,
}
