local gears = gears or require'gears'
local wibox = wibox or require'wibox'
local awful = awful or require'awful'

-- {{{
local sinks = {}
local sink
local sinkch

local get_rawinfo_ref = function()
	for line in io.popen("env LC_ALL=C pactl list sinks"):lines() do
		if line:match("^Sink%s*#%d+") then
			sinkch = tonumber(line:match("^Sink%s*#(%d+)"))
			sink = {}
			sinks[sinkch] = sink
		else
			local k, v = line:match("^%s*([^:]-):%s+(.-)%s*$")
			if k and v and #v > 0 then
				if k:lower() == "mute" then
					v = not v:match("no")
				end
				sink[k:lower()] = v
			end
		end
	end
end

get_rawinfo_ref()

local get_volume = function(ch)
	get_rawinfo_ref()
	local vols = sinks[ch].volume
	local vleft, vright = vols:match("(%d+%.?%d+)%%(.*)")
	vright = vright:match("(%d+%.?%d+)%%")
	vleft, vright = tonumber(vleft), tonumber(vright)

	return vleft, vright, sinks[ch].mute
end


local normal_color = "#cc8400"
local muted_color = "red"

local function toggled_color(muted)
	if muted then return muted_color
	else return normal_color
	end
end

local volumebar = wibox.widget {
	{
		color = toggled_color(sinks[sinkch].mute),
		background_color = "black",

		min_value = 0,
		max_value = 100,
		value = 100,
		border_width= 0,
		forced_width = 60,
		id = "barrepr",
		muted = sinks[sinkch].mute,
		widget = wibox.widget.progressbar
	},
	{
		text = "...",
		align = "center",
		id = "textrepr",

		widget = wibox.widget.textbox
	},

	layout = wibox.layout.stack,
	set_volume = function(self, vol, muted)
		self.textrepr.text = ("%d%%"):format(vol)
		self.barrepr.value = vol
		self.barrepr.muted = muted
		self.barrepr.color = toggled_color(muted)
	end
}

local vol_callback = function()
	local vleft, vright, muted = get_volume(sinkch)
	volumebar:set_volume((vleft+vright)/2, muted)
end

local update_volume = function(ch, vol, up)
	awful.spawn.easy_async_with_shell(
		([[pactl set-sink-volume %d %s%d%%]]):format(ch, (up and "+" or "-"), vol), vol_callback)
end

local toggle_volume = function(ch)
	awful.spawn.easy_async_with_shell(
		([[pactl set-sink-mute %d toggle]]):format(ch), vol_callback)
end

gears.timer {
	timeout = 2,
	autostart = true,
	callback = vol_callback
}

-- }}}

return {
	widget = volumebar,
	volup = function(vol)
		update_volume(sinkch, vol, true)
	end,
	voldown = function(vol)
		update_volume(sinkch, vol, false)
	end,
	toggle = function()  toggle_volume(sinkch) end
}

