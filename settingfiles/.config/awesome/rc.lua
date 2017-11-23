-- Standard awesome library
gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
wibox = require("wibox")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
-- local menubar = require("menubar")
-- local hotkeys_popup = require("awful.hotkeys_popup").widget
-- myfunc
myfuncs = require("myfuncs")
shortcuts = require("shortcuts")
autostart = require("autostart")
local init_lock = os.getenv("INIT_AWESOME_LOCK") or "/tmp/init_awesome.lock"
local file_readable = awful.util.file_readable
local conf_dir = awful.util.get_configuration_dir()

local function notify_error(err, notifyarg)
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

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  notify_error(awesome.startup_errors, {title = "Oops, there were errors during startup!"})
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
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
  theme.font = "Comfortaa 8"
  naughty.config.defaults.font = theme.font
  beautiful.init(theme)
end

naughty.config.defaults.timeout = 5
-- }}}

-- This is used later as the default terminal and editor to run.
-- local terminal = "lilyterm"
-- local editor = os.getenv("EDITOR") or "vim"
-- local editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

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

local mymainmenu = awful.menu({items= {
  -- {"hotkeys", function() return false, hotkeys_popup.show_help end}, 
  {"restart", awesome.restart}}})

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
  awful.button({ }, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1,
    function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3,
    function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end),
  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end))

local mytasklist = {}
mytasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
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

  awful.button({ }, 3, (function()
    local instance = nil

    return function ()
      if instance and instance.wibox.visible then
        instance:hide()
        instance = nil
      else
        instance = awful.menu.clients({ theme = { width = 250 } })
      end
    end
  end)()),

  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
    -- if client.focus then client.focus:raise() end
  end),

  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
    -- if client.focus then client.focus:raise() end
  end))

local screen_init

do
  local wallpapers = {
    "wallpaper1.png",
    "wallpaper2.png"
  }

  local function set_wallpaper(wallpaper_path, screen_or_screenidx)
    if file_readable(wallpaper_path) then
      xpcall(gears.wallpaper.fit, notify_error, wallpaper_path, screen_or_screenidx)
    end
  end

  screen_init = function(scr--[[screen object]])
    local wallpaper = conf_dir .. wallpapers[(scr.index - 1) % 2 + 1]
    set_wallpaper(wallpaper, scr)

    awful.tag({1, 2, 3, 4, 5}, scr, awful.layout.layouts[1])
    scr.mypromptbox = awful.widget.prompt()
    scr.mylayoutbox = awful.widget.layoutbox(scr)
    scr.mylayoutbox:buttons(awful.util.table.join(
      awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
      awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
      awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
      awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    scr.mytaglist = awful.widget.taglist(scr, awful.widget.taglist.filter.all, mytaglist.buttons)
    scr.mytasklist = awful.widget.tasklist(scr, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    scr.mywibox = awful.wibox({position = "top", screen = scr})

    scr.mywibox:setup {
      layout = wibox.layout.align.horizontal,
      { -- left widgets
        layout = wibox.layout.fixed.horizontal,
        mylauncher,
        scr.mytaglist,
        scr.mypromptbox
      },
      scr.mytasklist, -- middle widgets
      { -- right widgets
        layout = wibox.layout.fixed.horizontal,
        (function() if scr.index == 1 then return wibox.widget.systray() end end)(),
        scr.mylayoutbox}}
  end
end

awful.screen.connect_for_each_screen(screen_init)

screen.connect_signal("added", function(...)
  local screens = {...}
  table.remove(screens)
  for _, scr in pairs(screens) do
    screen_init(scr)
  end
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
  awful.button({ }, 3, function () mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  -- Layout manipulation
  awful.key({ modkey,       }, "Tab",
       function ()
         awful.client.focus.history.previous()
         if client.focus then
           client.focus:raise()
         end
       end),

  -- Standard program
  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Shift"   }, "l", function () awful.client.swap.byidx(1) awful.layout.set(awful.layout.suit.tile.left) end),
  awful.key({ modkey, "Shift"   }, "h", function () awful.client.swap.byidx(1) awful.layout.set(awful.layout.suit.tile) end),
  awful.key({modkey}, "l", function(c) return myfuncs.halfsize(c, "l") end),
  awful.key({modkey}, "h", function(c) return myfuncs.halfsize(c, "h") end),
  awful.key({ modkey,       }, "s", function () awful.client.swap.byidx(1) awful.layout.set(awful.layout.suit.fair) end),
  awful.key({ modkey,       }, "Return", function () awful.layout.set(awful.layout.suit.floating) end),

  -- Prompt
  awful.key({ modkey },      "r",   function () awful.screen.focused().mypromptbox:run() end), {})

clientkeys = awful.util.table.join(
  awful.key({ modkey,       }, "f",    function (c) myfuncs.toggle(c, "f")  end),
  awful.key({ "Mod1"      }, "q",    function (c) c:kill()             end),
  awful.key({ modkey,       }, "k", function (c) if not c.fullscreen then myfuncs.toggle(c, "hv") end end),
  awful.key({modkey, "Mod1"}, "l", function(c) return myfuncs.setwindowsize(c, "l") end, {description = "set client to be half of the screen", group = "client"}),
  awful.key({modkey, "Mod1"}, "k", function(c) return myfuncs.setwindowsize(c, "k") end),
  awful.key({modkey, "Mod1"}, "j", function(c) return myfuncs.setwindowsize(c, "j") end),
  awful.key({modkey, "Mod1"}, "h", function(c) return myfuncs.setwindowsize(c, "h") end),
  awful.key({modkey, "Mod1", "Shift"}, "l", function(c) return myfuncs.setwindowsize(c, "l", true) end),
  awful.key({modkey, "Mod1", "Shift"}, "k", function(c) return myfuncs.setwindowsize(c, "k", true) end),
  awful.key({modkey, "Mod1", "Shift"}, "j", function(c) return myfuncs.setwindowsize(c, "j", true) end),
  awful.key({modkey, "Mod1", "Shift"}, "h", function(c) return myfuncs.setwindowsize(c, "h", true) end),
  awful.key({modkey}, "e", function(c) return awful.titlebar.toggle(c) end))

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
          function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
               tag:view_only()
            end
          end,
          {description = "view tag #"..i, group = "tag"}),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
          function ()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
             awful.tag.viewtoggle(tag)
            end
          end,
          {description = "toggle tag #" .. i, group = "tag"}),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
          function ()
            if client.focus then
              local tag = client.focus.screen.tags[i]
              if tag then
                client.focus:move_to_tag(tag)
              end
           end
          end,
          {description = "move focused client to tag #"..i, group = "tag"}),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
          function ()
            if client.focus then
              local tag = client.focus.screen.tags[i]
              if tag then
                client.focus:toggle_tag(tag)
              end
            end
          end,
          {description = "toggle focused client on tag #" .. i, group = "tag"}))
end

local clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ "Shift" }, 1,  awful.mouse.client.move),
  awful.button({ modkey,  }, 3, awful.mouse.client.resize))

-- Set keys
if file_readable(conf_dir .. 'shortcuts') then
  xpcall(shortcuts, function(e)
    notify_error(e); root.keys(globalkeys)
  end, globalkeys, 'shortcuts')
else
  root.keys(globalkeys)
end

myfuncs.domyconf("extkey.lua")
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  callback = function (c)
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
      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
	  maximized = false,
    },
    callback = awful.rules.rules.callback
  },
  -- {
    -- rule = {class = "Mplayer"},
    -- properties = {floating = true, focus = true}
  -- },
  {
    rule = {class = "Gimp"},
    properties = {floating = true}
  },
  -- {
    -- rule = {class = "Tilda"},
    -- properties = {floating = true},
    -- callback = function(c) myfuncs.toggle("f", c) c.ontop = not c.ontop end
  -- },
  -- Floating clients.
  { rule_any = {
    instance = {
      "DTA",  -- Firefox addon DownThemAll.
      "copyq",  -- Includes session name in class.
    },
    class = {
      "Arandr",
      "Gpick",
      "Kruler",
      "MessageWin",  -- kalarm.
      "Sxiv",
      "Wpa_gui",
      "pinentry",
      "veromix",
      "xtightvncviewer"},

    name = {
      "Event Tester",  -- xev.
    },
    role = {
      "AlarmWindow",  -- Thunderbird's calendar.
      "pop-up",     -- e.g. Google Chrome's (detached) Developer Tools.
    }
    }, properties = { floating = true }},

  -- Add titlebars to normal clients and dialogs
  { rule_any = {type = { "normal", "dialog" }
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
client.connect_signal("manage", function (c)
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
    awful.button({ }, 1, function()
      client.focus = c
      c:raise()
      awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
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
      awful.titlebar.widget.floatingbutton (c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton   (c),
      awful.titlebar.widget.ontopbutton  (c),
      awful.titlebar.widget.closebutton  (c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }

  awful.titlebar.hide(c)
end)

client.connect_signal("mouse::enter", function(c)
  if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    and awful.client.focus.filter(c) then
    client.focus = c
  end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

xpcall(function()
  local autostart_ini = conf_dir .. "autostart"
  local autostart_cmds

  if file_readable(autostart_ini) then
    autostart_cmds = autostart.read(conf_dir .. "autostart")

    autostart.run(autostart_cmds.anytime)
  end

  if file_readable(init_lock) then
    if autostart_cmds then
      autostart.run(autostart_cmds.oneshot)
    end

    awful.util.spawn("rm " .. init_lock)
  end

  if file_readable(conf_dir .. "battery_alert.lua") then
    require'battery_alert'
  end
end, notify_error)

