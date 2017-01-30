local awful = awful or require('awful')
local myfuncs = myfuncs or require('myfuncs')
local modkey = modkey
local sndc = os.getenv("SNDC") or 1
local keyreg
keyreg = function(metas, key, fn)
	local todof
	if type(fn) == "string" then
		todof = function()
			return awful.util.spawn_with_shell(fn)
		end
	else
		todof = function()
			return fn()
		end
	end
	return awful.key(metas, key, todof)
end

local globalkeys = root.keys()
globalkeys = awful.util.table.join(
	keyreg({ "Shift", "Control" }, "x", "firefox"),
	keyreg({ "Shift", "Control" }, "a", "google-chrome-stable"),
	keyreg({ "Shift", "Control" }, "f", "thunar"),
	keyreg({ }, "Print", "$HOME/bin/scshot"),
	keyreg({ "Shift" }, "Print", "$HOME/bin/scshot a"),
	keyreg({}, "XF86MonBrightnessUp", "xbacklight -inc 3"),
	keyreg({}, "XF86MonBrightnessDown", "xbacklight -dec 3"),
	keyreg({}, "XF86AudioRaiseVolume", "amixer -c 1 set Master 1%+"),
	keyreg({}, "XF86AudioLowerVolume", "amixer -c 1 set Master 1%-"),
	keyreg({}, "XF86AudioMute", "amixer -c 1 set Master toggle && amixer -c 1 set Headphone on && amixer -c 1 set Speaker on"),
	keyreg({}, "Insert", "$HOME/bin/lidlock.sh"),
	keyreg({ modkey }, "p", myfuncs.squaresize),
	globalkeys)

root.keys(globalkeys)

