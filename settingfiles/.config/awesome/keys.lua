-- {{{ Key bindings
globalkeys = awful.util.table.join(
awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

awful.key({ modkey,           }, "j",
function ()
	awful.client.focus.byidx( 1)
	if client.focus then client.focus:raise() end
end),
-- awful.key({ modkey,           }, "k",
-- function ()
-- awful.client.focus.byidx(-1)
-- if client.focus then client.focus:raise() end
-- end),

-- Layout manipulation
awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
-- awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
awful.key({ modkey,           }, "Tab",
function ()
	awful.client.focus.history.previous()
	if client.focus then
		client.focus:raise()
	end
end),

-- Standard program
awful.key({ "Control", "Shift" }, "n", function () awful.util.spawn(terminal) end),
awful.key({ "Control", "Shift" }, "x", function () awful.util.spawn("firefox") end),
awful.key({ "Control", "Shift" }, "a", function () awful.util.spawn("chromium") end),
awful.key({ "Control", "Shift" }, "f", function () awful.util.spawn("thunar") end),
awful.key({ "Control", "Shift" }, "t", function () awful.util.spawn("thunderbird") end),
awful.key({ "Control", "Shift" },"F12",function () awful.util.spawn("tilda") end),
awful.key({                    },"Print",function () awful.util.spawn("/home/beshowjo/bin/scshot") end),
awful.key({ "Shift"            }, "Print", function () awful.util.spawn("/home/beshowjo/bin/scshot a") end),
awful.key({ modkey, "Mod1"     },  "l", function () awful.util.spawn("/home/beshowjo/bin/setwsize.sh -l") end),
awful.key({ modkey, "Mod1"     },  "k", function () awful.util.spawn("/home/beshowjo/bin/setwsize.sh -k") end),
awful.key({ modkey, "Mod1"     },  "j", function () awful.util.spawn("/home/beshowjo/bin/setwsize.sh -j") end),
awful.key({ modkey, "Mod1"     },  "h", function () awful.util.spawn("/home/beshowjo/bin/setwsize.sh -h") end),
awful.key({ modkey, "Control" }, "r", awesome.restart),
awful.key({ modkey, "Shift"   }, "q", awesome.quit),

-- awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
-- awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
-- awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
awful.key({ modkey,           }, "l", function () awful.client.swap.byidx(1) awful.layout.set(awful.layout.suit.tile.left) end),
awful.key({ modkey,           }, "h", function () awful.client.swap.byidx(1) awful.layout.set(awful.layout.suit.tile) end),
-- awful.key({ modkey,           }, ";", function () awful.layout.set(awful.layout.suit.max) end),
awful.key({ modkey,           }, "Return", function () awful.layout.set(awful.layout.suit.floating) end),

awful.key({ modkey, "Control" }, "n", awful.client.restore),

-- Prompt
awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

-- awful.key({ modkey }, "x",
-- function ()
-- awful.prompt.run({ prompt = "Run Lua code: " },
-- mypromptbox[mouse.screen].widget,
-- awful.util.eval, nil,
-- awful.util.getdir("cache") .. "/history_eval")
-- end),
-- Menubar
-- awful.key({ modkey }, "p", function() menubar.show() end)
{}
)

clientkeys = awful.util.table.join(
awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
awful.key({ "Mod1"            }, "q",      function (c) c:kill()                         end),
awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
awful.key({ modkey,           }, "n",
function (c)
	-- The client currently has the input focus, so it cannot be
	-- minimized, since minimized clients can't have the focus.
	c.minimized = true
end),
awful.key({ modkey,           }, "k",
function (c)
	if not c.fullscreen then
		c.maximized_horizontal = not c.maximized_horizontal
		c.maximized_vertical   = not c.maximized_vertical
	end
end))

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
	-- View tag only.
	awful.key({ modkey }, "#" .. i + 9,
	function ()
		local screen = mouse.screen
		local tag = awful.tag.gettags(screen)[i]
		if tag then
			awful.tag.viewonly(tag)
		end
	end),
	-- Toggle tag.
	awful.key({ modkey, "Control" }, "#" .. i + 9,
	function ()
		local screen = mouse.screen
		local tag = awful.tag.gettags(screen)[i]
		if tag then
			awful.tag.viewtoggle(tag)
		end
	end),
	-- Move client to tag.
	awful.key({ modkey, "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = awful.tag.gettags(client.focus.screen)[i]
			if tag then
				awful.client.movetotag(tag)
			end
		end
	end),
	-- Toggle tag.
	awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
	function ()
		if client.focus then
			local tag = awful.tag.gettags(client.focus.screen)[i]
			if tag then
				awful.client.toggletag(tag)
			end
		end
	end))
end

clientbuttons = awful.util.table.join(
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
awful.button({ "Shift" }, 1,  awful.mouse.client.move),
awful.button({ modkey,  }, 3, awful.mouse.client.resize))


local extkey = "extkey"

if io.open(extkey) then
	loadfile(extkey .. ".lua")
	io.close(exykey .. ".lua")
end

-- Set keys
root.keys(globalkeys)
-- }}}
