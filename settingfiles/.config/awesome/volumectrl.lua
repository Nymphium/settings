local gears = gears or require'gears'
local wibox = wibox or require'wibox'
local awful = awful or require'awful'

if io.popen("pactl"):close() then
	return {
		widget = nil,
		volup = function() end,
		voldown = function() end,
		toggle = function() end
	}
end

-- {{{
local get_rawinfo_ref = function()
	local sinks = {}
	local sink
	local sinkch

	for line in io.popen("env LC_ALL=C pactl list sinks"):lines() do
		if line:match("^Sink%s*#%d+") then
			sinkch = tonumber(line:match("^Sink%s*#(%d+)"))
			sink = {}
			sink.channel = sinkch
			sinks[sinkch] = sink
		else
			local k, v = line:match("^%s*([^:]-):%s+(.-)%s*$")
			if k and v and #v > 0 then
				if k == "State" then
					sink.is_running = v == "RUNNING"
				elseif k == "Active Port" then
					sink.port = v
				elseif k == "Mute" then
					v = not (v == "no")
					sink.mute = v
				elseif k == "Volume" then
					local voll, volr = v:match("(%d+)%%")

					-- if stereo
					if volr then
						voll = tonumber(voll)
						volr = tonumber(volr)
						sink.volume = (voll + volr)
					else
						sink.volume = tonumber(voll)
					end
				end
			end
		end
	end

	for _, sink in pairs(sinks) do
		if sink.is_running then
			return sink
		end
	end
end

get_rawinfo_ref() -- }}}

local normal_color = "#cc8400"
local muted_color = "red"

local function toggled_color(muted)
	if muted then return muted_color
	else return normal_color
	end
end

local volumebar = wibox.widget { -- {{{
	{
		color = muted_color,
		background_color = "black",

		min_value = 0,
		max_value = 100,
		value = 100,
		border_width= 0,
		forced_width = 60,
		id = "barrepr",
		muted = true,
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
} -- }}}


local tooltip = awful.tooltip{ -- {{{
	objects = {volumebar},
	delay_show = 1
}

local update_tooltip = function(port, vol, muted)
	local txt = ([[
Port: %s
Volume: %d%%
Muted: %s]]):format(port, vol, muted)

	tooltip:set_text(txt)
end -- }}}


-- {{{
local get_volume = function(ch)
	local sink = get_rawinfo_ref()

	return sink.port, sink.volume, sink.mute
end

local vol_callback = function()
	local port, vol, muted = get_volume(sinkch)
	volumebar:set_volume(vol, muted)
	update_tooltip(port, vol, muted)
end

local update_volume = function(ch, vol, up)
	awful.spawn.easy_async_with_shell(
		([[pactl set-sink-volume %d %s%d%%]]):format(ch, (up and "+" or "-"), vol), vol_callback)
end

local toggle_volume = function(ch)
	awful.spawn.easy_async_with_shell(
		([[pactl set-sink-mute %d toggle]]):format(ch), vol_callback)
end
-- }}}

gears.timer {
	timeout = 2,
	autostart = true,
	callback = vol_callback
}
-- }}}


volumebar:connect_signal("button::press", function()
	awful.spawn.easy_async_with_shell("pavucontrol", vol_callback)
end)

return {
	widget = volumebar,
	volup = function(vol)
		local sink = get_rawinfo_ref()
		update_volume(sink.channel, vol, true)
	end,
	voldown = function(vol)
		local sink = get_rawinfo_ref()
		update_volume(sink.channel, vol, false)
	end,
	toggle = function()
		local sink = get_rawinfo_ref()
		toggle_volume(sink.channel)
	end
}

