local gears = gears or require'gears'
local wibox = wibox or require'wibox'
local naughty = naughty or require'naughty'
local awful = awful or require'awful'

local batmax = 0
local filenametmp = "/sys/class/power_supply/"

local file_prefix = "energy"

for i = 0, 9 do
	local capacity_full_file = io.open(("%s/BAT%d/%s_full"):format(filenametmp, i, file_prefix))

	if not capacity_full_file then
		file_prefix = "charge"

		capacity_full_file = io.open(("%s/BAT%d/charge_full"):format(filenametmp, i))

		if not capacity_full_file then
			break
		end
	end

	local batmaxi = capacity_full_file:read("*a")

	batmax = batmax + tonumber(batmaxi)
	assert(capacity_full_file:close())
end

if batmax == 0 then
	return {
		widget = nil
	}
end

local get_battery = function() -- {{{
	-- batteries capacity {{{
	local batnow =  0

	for i = 0, 9 do
		local capacity_file = io.open(("%s/BAT%d/%s_now"):format(filenametmp, i, file_prefix))

		if not capacity_file then
			break
		end

		local batnowi = capacity_file:read("*a")
		assert(capacity_file:close())

		batnow = batnow + tonumber(batnowi)
	end
	-- }}}

	-- if ac? {{{
	local ac = io.open(("%s/AC/online"):format(filenametmp))
	local charged = ac:read("*a"):match("1")
	assert(ac:close())
	-- }}}

	return (batnow * 100 / batmax), not not charged
end -- }}}

local batterywidget = wibox.widget { -- {{{
	{
		min_value    = 0,
		max_value    = 100,
		value        = 100,
		charged      = false,
		border_width = 0,
		forced_width = 60,
		color        = "#405922",
		background_color = "#06f",
		id           = "barrepr",
		widget       = wibox.widget.progressbar,
	},
	{
		id           = "textrepr",
		text         = "...",
		align        = 'center',
		widget       = wibox.widget.textbox,
	},
	layout      = wibox.layout.stack,
	warn_first = true,
	alert_first = true,
	set_battery = function(self, val, charged)
		self.textrepr.text  = ("%s%.1f%%"):format(charged and "C " or "D ", val)
		self.barrepr.value = val
		self.barrepr.charged = charged

		if charged then
			self.warn_first = true
			self.alert_first = true
		else
			if val <= 20 and self.warn_first then
				naughty.notify({
				   title = "Battery",
				   text = ("%.2f%% left"):format(val),
				   timeout = 19
			   })

				self.warn_first = false
			elseif val <= 10 and self.alert_first then
				naughty.notify({
				   title = "Battery",
				   text = ("%.2f%% left"):format(val),
				   timeout = 19
			   })

				self.alert_first = false
			end
		end
	end,
} -- }}}

local tooltip = awful.tooltip({
			  objects = {batterywidget},
			  delay_show = 1
		  })

local update_tooltip = function()
	local val, charged = get_battery()

	local txt = ([[
Battery: %.1f%%
State: %s]]):format(val, charged and "charged" or "ac")

	tooltip:set_text(txt)
end

local batt_callback = function () -- {{{
	local bat, charged = get_battery()
	batterywidget:set_battery(bat, charged)
	update_tooltip()
end -- }}}

gears.timer {
	timeout   = 2,
	autostart = true,
	callback  = batt_callback
}

return {
	widget = batterywidget
}
