-- Standard awesome library
gears = require("gears")
local gears = gears
awful = require("awful")
local awful = awful
rules = require("awful.rules")
local rules = rules
require("awful.autofocus")
wibox = require("wibox")
local wibox = wibox
beautiful = require("beautiful")
local beautiful = beautiful
naughty = require("naughty")
local naughty = naughty
myfuncs = require("myfuncs")
local myfuncs = myfuncs
local shortcuts = require("shortcuts")
local autostart = require("autostart")
local battery = require "battery"
cairo = require('lgi').cairo
local cairo = cairo

local client = client
local screen = screen

local file_readable = awful.util.file_readable
local conf_dir = awful.util.get_configuration_dir()

function notify_error(err, notifyarg)
  notifyarg = notifyarg or {}
  naughty.notify(
    awful.util.table.join(
      {
        preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = tostring(err)
      },
      notifyarg))
end

local get_tag_clients = function()
  return awful.screen.focused().selected_tag:clients()
end

local unmaximize_clients = function(tag_clients)
  for _, c in pairs(tag_clients) do
    if not c.hidden and (c.maximized_vertical or c.maximized_horizontal) then
      c.maximized_vertical = false
      c.maximized_horizontal = false
    end
  end
end

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  notify_error(awesome.startup_errors, { title = "Oops, there were errors during startup!" })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    -- naughty.notify({
    -- preset = naughty.config.presets.critical,
    -- title = "Oops, an error happened!",
    -- text = tostring(err),
    -- height = 80,
    -- timeout = 10
    -- })
    notify_error(err)
    in_error = false
  end)
end
-- }}}

-- {{{ Variable definitions
local theme_lua = awful.util.checkfile(awful.util.get_themes_dir() .. "default/theme.lua")

if type(theme_lua) == "function" then
  local theme = theme_lua()
  theme.font = "sans 8"
  naughty.config.defaults.font = theme.font
  beautiful.init(theme)
end

naughty.config.defaults.timeout = 5
-- }}}

-- This is used later as the default terminal and editor to run.
local terminal = "urxvtc"
-- local editor = os.getenv("EDITOR") or "vim"
-- local editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- local dropdownterminal

-- xpcall(function()
-- local ddt = require("dropdownterminal")
-- local term = ddt(terminal)
-- dropdownterminal = term

-- globalkeys = globalkeys or {}
-- globalkeys = awful.util.table.join(globalkeys,
-- awful.key({ "Mod1", "Shift" }, "j", function() return term:view_toggle() end),
-- awful.key({ "Mod1", "Control" }, "j", function() return term:show_always_toggle() end))
-- end, notify_error)


local quake = require('quake')
awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  s.quake = quake({ app = "alacritty", argname = "--title %s", extra = "--class QuakeDD",
    visible = true, height = 1,
    screen = s })
end)

globalkeys = globalkeys or {}
globalkeys = awful.util.table.join(globalkeys,
  awful.key({ "Mod1", "Shift" }, "j", function() awful.screen.focused().quake:toggle() end)
)

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts = {
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier
}
awful.layout.layouts = layouts
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
-- myawesomemenu = {
-- { "manual", terminal .. " -e man awesome" },
-- { "edit config", editor_cmd .. " " .. awesome.conffile },
-- { "restart", awesome.restart },
-- { "quit", awesome.quit }
-- }

local mymainmenu = awful.menu({ items = {
  -- {"hotkeys", function() return false, hotkeys_popup.show_help end},
  { "restart", awesome.restart }
} })

local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
-- menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
-- mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
-- local mywibox = {}
-- local mypromptbox = {}
-- local mylayoutbox = {}
local mytaglist = {}
mytaglist.buttons = awful.util.table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1,
    function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3,
    function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end),
  awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end))

local mytasklist = {}
mytasklist.buttons = awful.util.table.join(
  awful.button({}, 1, function(c)
    if c ~= client.focus then
      -- c.minimized = true
      -- else
      -- Without this, the following
      -- :isvisible() makes no sense
      c.minimized = false
      if not c:isvisible() then
        c.first_tag:view_only()
      end
      -- This will also un-minimize
      -- the client, if needed
      client.focus = c
      c:raise()
    end
  end),

  awful.button({}, 3, (function()
    local instance = nil

    return function()
      if instance and instance.wibox.visible then
        instance:hide()
        instance = nil
      else
        instance = awful.menu.clients({ theme = { width = 250 } })
      end
    end
  end)()),

  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
    -- if client.focus then client.focus:raise() end
  end),

  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
    -- if client.focus then client.focus:raise() end
  end))

local screen_init

do
  local wallpapers = {
    "wallpaper1.png",
    "wallpaper2.png",
    "wallpaper3.png",
    "wallpaper4.png",
    "wallpaper5.png",
    "wallpaper6.png",
    "wallpaper7.png",
    "wallpaper8.png",
    "wallpaper9.png",
  }



  local function set_wallpaper(scr, wallpaper)
    local hash = tonumber(tostring(scr):match("0x[0-9]+"))

    local function go(idx)
      local wallpaper = conf_dir .. wallpapers[((hash + idx) % #wallpapers) + 1]

      if file_readable(wallpaper) then
        xpcall(function()
          gears.wallpaper.maximized(wallpaper, scr)
        end, notify_error)
      elseif idx < #wallpapers then
        go(idx + 1)
      end
    end

    go(0)
  end

  -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
  screen.connect_signal("property::geometry", function(s)
    set_wallpaper(s, wallpaper)
  end)

  screen_init = function(scr --[[screen object]])
    set_wallpaper(scr, wallpaper)

    awful.tag({ 1, 2, 3, 4, 5 }, scr, awful.layout.layouts[1])
    scr.mypromptbox = awful.widget.prompt({ with_shell = true })
    scr.mylayoutbox = awful.widget.layoutbox(scr)
    scr.mylayoutbox:buttons(awful.util.table.join(
      awful.button({}, 1, function() awful.layout.inc(layouts, 1) end),
      awful.button({}, 3, function() awful.layout.inc(layouts, -1) end),
      awful.button({}, 4, function() awful.layout.inc(layouts, 1) end),
      awful.button({}, 5, function() awful.layout.inc(layouts, -1) end)))

    scr.mytaglist = awful.widget.taglist(scr, awful.widget.taglist.filter.all, mytaglist.buttons)
    scr.mytasklist = awful.widget.tasklist(scr, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    scr.mywibox = awful.wibar({ position = "top", screen = scr })

    local right_widget = {
      layout = wibox.layout.fixed.horizontal
    }

    if scr == screen.primary then
      table.insert(right_widget, wibox.widget.systray())
      table.insert(right_widget, wibox.widget.textclock())

      local has_volumectrl, _volumectrl = pcall(require, "volumectrl")
      if has_volumectrl and _volumectrl.widget then
        volumectrl = _volumectrl

        table.insert(right_widget, volumectrl.widget)
      end

      if battery.widget then
        table.insert(right_widget, battery.widget)
      end
    end

    table.insert(right_widget, scr.mylayoutbox)

    scr.mywibox:setup {
      layout = wibox.layout.align.horizontal,
      { -- left widgets
        layout = wibox.layout.fixed.horizontal,
        mylauncher,
        scr.mytaglist,
        scr.mypromptbox
      },
      scr.mytasklist, -- middle widgets
      right_widget
    }
  end
end

awful.screen.connect_for_each_screen(screen_init)

screen.connect_signal("added", function(...)
  local screens = { ... }
  table.remove(screens)
  for _, scr in pairs(screens) do
    screen_init(scr)
  end
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
  awful.button({}, 3, function() mymainmenu:toggle() end),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)))
-- }}}

local filter = function(t, p)
  local t_ = {}

  for i = 1, #t do
    if p(t[i]) then
      table.insert(t_, t[i])
    end
  end

  return t_
end

local filter_ddt = function(clients)
  if not dropdownterminal then return clients
  else
    return filter(clients,
      function(e)
        return e ~= dropdownterminal.client
      end)
  end
end

-- local toggleclient do --{{{
-- local global_popup
-- local new_widget = require('preview_widget')
-- toggleclient = function()
-- if global_popup then
-- global_popup.visible = false
-- global_popup = nil

-- return
-- end

-- local clients = filter_ddt(get_tag_clients())
-- local num_of_clients = #clients
-- local columns = num_of_clients <= 5 and num_of_clients or 5
-- local multipl = 1 / ((num_of_clients + 2) / num_of_clients)

-- local wiboxes = {
-- layout = wibox.layout.grid,
-- homogeneous = true,
-- spacing = 1,
-- orientation = 'vertical',
-- forced_num_cols = columns
-- }

-- local on_destroy = function()
-- for i = 1, num_of_clients do
-- wiboxes[i].preview._private.srf[1]:finish()
-- end
-- end

-- if num_of_clients == 0 then
-- if global_popup then
-- global_popup.visible = false
-- on_destroy()
-- global_popup = nil
-- end

-- return
-- end

-- local font do
-- local font_orig = beautiful.font:match('^(.*)( %d+)?$')
-- local font_size = 14
-- font = ('%s %d'):format(font_orig, font_size)
-- end

-- local current_screen = awful.screen.focused()

-- local size_base = current_screen.geometry.width / 16 / (columns * 1.3) * multipl
-- local grid_width = size_base * 16
-- local grid_height = size_base * 9

-- for _, c in ipairs(clients) do
-- local box = wibox.widget {
-- {
-- id = "title",
-- {
-- text = c.class,
-- font = font,
-- align = 'center',
-- forced_width = grid_width,
-- widget = wibox.widget.textbox,
-- },
-- fg = 'gray',
-- widget = wibox.container.background
-- },
-- {
-- id = "preview",
-- widget = new_widget,
-- client = c,
-- forced_height = grid_height,
-- forced_width = grid_width
-- },
-- client = c,
-- layout = wibox.layout.align.vertical,
-- widget = wibox.container.background,
-- }

-- table.insert(wiboxes, box)
-- end

-- local popup = awful.popup {
-- widget = {
-- wiboxes,
-- widget  = wibox.container.margin
-- },
-- screen = current_screen,
-- placement = awful.placement.centered,
-- hide_on_right_click = true,
-- shape = gears.shape.rounded_rect,
-- opacity = 0.95,
-- ontop = true,
-- on_destroy = on_destroy
-- }

-- if global_popup then
-- global_popup.visible = false
-- global_popup = nil
-- end

-- global_popup = popup

-- for i = 1, num_of_clients do
-- local c = wiboxes[i].client

-- wiboxes[i]:connect_signal("button::press", function()
-- client.focus = c
-- client.focus:raise()
-- global_popup = nil
-- popup.visible = false
-- on_destroy()
-- end)

-- local timer; timer = gears.timer {
-- timeout = 0.05,
-- callback = function()
-- local popuped = not not global_popup

-- if popuped then
-- wiboxes[i].preview:emit_signal("widget::redraw_needed")
-- else
-- timer:stop()
-- end
-- end
-- }

-- timer:start()
-- end
-- end
-- end
--}}}

local mouse_client_rotate = function(_)
  return function(is_backward)
    local screen_index_under_mouse = mouse.screen.index
    local screen_index_focused = client.focus and client.focus.screen.index or nil
    local num_of_screens = screen:count()

    if screen_index_focused and screen_index_under_mouse ~= screen_index_focused then
      client.focus = mouse.current_client
      return
    end

    local next_idx = is_backward and
        (screen_index_under_mouse ~= 1 and (screen_index_under_mouse - 1) or num_of_screens)
        or
        (screen_index_under_mouse ~= num_of_screens and (screen_index_under_mouse + 1) or 1)

    local scr_geom = screen[next_idx].geometry
    local mouse_geom = {
      x = scr_geom.x + scr_geom.width / 2,
      y = scr_geom.y + scr_geom.height / 2
    }

    mouse.coords(mouse_geom)
  end
end

-- {{{ Key bindings
globalkeys = awful.util.table.join(globalkeys or {},
  awful.key({ modkey }, "m", mouse_client_rotate(false)),
  awful.key({ modkey, "Shift" }, "m", mouse_client_rotate(true)),

  -- Layout manipulation
  awful.key({ modkey, }, "Tab",
    function()
      local clients = filter_ddt(get_tag_clients())
      local num = #clients

      if dropdownterminal and client.focus == dropdownterminal.client then
        dropdownterminal:view_toggle()
        return
      elseif num > 1 then
        local theclient

        if not client.focus then
          theclient = clients[1]
        else
          for i = num, 1, -1 do
            if clients[i] == client.focus then
              theclient = clients[(num + i - 2) % num + 1]
              break
            end
          end
        end

        client.focus = theclient
        theclient.first_tag:view_only()
        theclient:raise()
      end
    end),

  -- awful.key({ modkey }, 't', toggleclient),

  awful.key({ modkey, "Shift" }, "Tab",
    function()
      local clients = filter_ddt(get_tag_clients())
      local num = #clients

      if dropdownterminal and client.focus == dropdownterminal.client then
        dropdownterminal:view_toggle()
      end

      if num > 1 then
        local theclient

        if not client.focus then
          theclient = clients[1]
        else
          for i = 1, num do
            if clients[i] == client.focus then
              theclient = clients[i % num + 1]
              break
            end
          end
        end

        client.focus = theclient
        theclient.first_tag:view_only()
        theclient:raise()
      end
    end),

  awful.key({ modkey, "Control" }, "Tab",
    function()
      local clients = filter_ddt(client.get())
      local num = #clients

      if dropdownterminal and client.focus == dropdownterminal.client then
        dropdownterminal:view_toggle()
      end

      if num > 1 then
        local theclient

        if not client.focus then
          theclient = clients[1]
        else
          for i = num, 1, -1 do
            if clients[i] == client.focus then
              theclient = clients[(num + i - 2) % num + 1]
              break
            end
          end
        end

        client.focus = theclient
        theclient.first_tag:view_only()
        theclient:raise()
      end
    end),

  awful.key({ modkey, "Shift", "Control" }, "Tab",
    function()
      local clients = filter_ddt(client.get())
      local num = #clients

      if dropdownterminal and client.focus == dropdownterminal.client then
        dropdownterminal:view_toggle()
      end

      if num > 1 then
        local theclient

        if not client.focus then
          theclient = clients[1]
        else
          for i = 1, num do
            if clients[i] == client.focus then
              theclient = clients[i % num + 1]
              break
            end
          end
        end

        client.focus = theclient
        theclient.first_tag:view_only()
        theclient:raise()
      end
    end),

  -- Standard program
  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Shift" }, "l", function()
    local layout = awful.layout.suit.tile.left

    if awful.layout.get() == layout then
      awful.client.cycle()
    else
      awful.layout.set(layout)
    end

    awful.client.focus.bydirection("left")
  end),
  awful.key({ modkey, "Shift" }, "h", function()
    local layout = awful.layout.suit.tile

    if awful.layout.get() == layout then
      awful.client.cycle()
    else
      awful.layout.set(layout)
    end

    awful.client.focus.bydirection("right")
  end),
  awful.key({ modkey, "Control" }, "l", function() awful.client.cycle() end--[[anti-clockwise]] ),
  awful.key({ modkey, "Control" }, "h", function() awful.client.cycle(true) end--[[clockwise]] ),
  awful.key({ modkey }, "l", function(c) return myfuncs.halfsize(c, "l") end),
  awful.key({ modkey }, "h", function(c) return myfuncs.halfsize(c, "h") end),
  awful.key({ modkey, }, "s", function()
    unmaximize_clients(get_tag_clients())

    awful.client.swap.byidx(1)
    awful.layout.set(awful.layout.suit.fair)
  end),
  awful.key({ modkey, }, "Return", function() awful.layout.set(awful.layout.suit.floating) end),

  -- awful.key({ modkey, }, "w" , xrandr.xrandr),

  -- Prompt
  awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end))

local clientkeys = awful.util.table.join(
  awful.key({ modkey, }, "f", function(c) myfuncs.toggle(c, "f") end),
  awful.key({ "Mod1" }, "q", function(c) c:kill() end),
  awful.key({ modkey, }, "k", function(c) if not c.fullscreen then myfuncs.toggle(c, "hv") end end),
  awful.key({ modkey, "Mod1" }, "l", function(c) return myfuncs.setwindowsize(c, "l") end),
  awful.key({ modkey, "Mod1" }, "k", function(c) return myfuncs.setwindowsize(c, "k") end),
  awful.key({ modkey, "Mod1" }, "j", function(c) return myfuncs.setwindowsize(c, "j") end),
  awful.key({ modkey, "Mod1" }, "h", function(c) return myfuncs.setwindowsize(c, "h") end),
  awful.key({ modkey, "Mod1", "Shift" }, "l", function(c) return myfuncs.setwindowsize(c, "l", true) end),
  awful.key({ modkey, "Mod1", "Shift" }, "k", function(c) return myfuncs.setwindowsize(c, "k", true) end),
  awful.key({ modkey, "Mod1", "Shift" }, "j", function(c) return myfuncs.setwindowsize(c, "j", true) end),
  awful.key({ modkey, "Mod1", "Shift" }, "h", function(c) return myfuncs.setwindowsize(c, "h", true) end),
  awful.key({ modkey }, "e", awful.titlebar.toggle))

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
      function()
        local scr = awful.screen.focused()
        local tag = scr.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      { description = "view tag #" .. i, group = "tag" }),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
      function()
        local scr = awful.screen.focused()
        local tag = scr.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      { description = "toggle tag #" .. i, group = "tag" }),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "move focused client to tag #" .. i, group = "tag" }),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      { description = "toggle focused client on tag #" .. i, group = "tag" }))
end

local clientbuttons = awful.util.table.join(
  awful.button({}, 1, function(c) client.focus = c; c:raise() end),
  awful.button({ "Shift" }, 1, awful.mouse.client.move),
  awful.button({ modkey, }, 3, awful.mouse.client.resize))


-- Set keys
if file_readable(conf_dir .. 'shortcuts') then
  xpcall(shortcuts, function(e)
    notify_error(e);
    root.keys(globalkeys)
  end, globalkeys, 'shortcuts')
else
  root.keys(globalkeys)
end

myfuncs.domyconf("extkey.lua")
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
rules.rules = {
  callback = function(c)
    awful.placement.centered(c, nil)
  end,

  {
    -- All clients will match this rule.
    rule = {},
    properties = {
      -- border_width = beautiful.border_width,
      -- border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      -- size_hints_honor = false,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      maximized = false,
    },
    callback = rules.rules.callback
  },
  -- {
  -- rule = {class = "Mplayer"},
  -- properties = {floating = true, focus = true}
  -- },
  {
    rule = { class = "Gimp" },
    properties = { floating = true }
  },
  -- {
  -- rule = {class = "Tilda"},
  -- properties = {floating = true},
  -- callback = function(c) myfuncs.toggle("f", c) c.ontop = not c.ontop end
  -- },
  -- Floating clients.
  { rule_any = {
    instance = {
      "DTA", -- Firefox addon DownThemAll.
      "copyq", -- Includes session name in class.
    },
    class = {
      "Arandr",
      "Gpick",
      "Kruler",
      "MessageWin", -- kalarm.
      "Sxiv",
      "Wpa_gui",
      "pinentry",
      "veromix",
      "xtightvncviewer"
    },

    name = {
      "Event Tester", -- xev.
    },
    role = {
      "AlarmWindow", -- Thunderbird's calendar.
      "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
    }
  }, properties = { floating = true } },

  -- Add titlebars to normal clients and dialogs
  { rule_any = { type = { "normal", "dialog" }
  }, properties = { titlebars_enabled = true }
  },
  {
    rule_any = {
      instance = {
        "DTA",
        "copyq"
      },
      class = {
        "Mplayer",
        "Vlc",
        "Mpv",
        "Tilda",
      },
      role = {
        "AlarmWindow",
        "pop-up"
      },

    }, properties = {
      floating = true,
      focus = true
    }
  }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = awful.util.table.join(
    awful.button({}, 1, function()
      client.focus = c
      c:raise()
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      client.focus = c
      c:raise()
      awful.mouse.client.resize(c)
    end))

  awful.titlebar(c):setup {
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
      { -- Title
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },
    { -- Right
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }

  awful.titlebar.hide(c)
end)

-- client.connect_signal("mouse::enter", function(c)
-- if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
-- and awful.client.focus.filter(c) then
-- client.focus = c
-- end
-- end)

client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

xpcall(function()
  local autostart_ini = conf_dir .. "autostart"

  if file_readable(autostart_ini) then
    awesome.connect_signal("startup", function()
      autostart(autostart_ini)
    end)
  end
end, notify_error)
