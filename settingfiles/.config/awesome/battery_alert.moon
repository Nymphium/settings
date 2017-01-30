_, _, acpi_exit_code = (io.popen "which acpi")\close!

if acpi_exit_code == 0
	awful or= require'awful'
	naughty or= require'naughty'
	timer or= require'timer'
	percent = 20
	INTERVAL_TIME = 30
	SIG_NAME = "timeout"

	battery_alert = ->
		local battery, exit_code
		with io.popen "acpi"
			battery = \read "*a"
			_, _, exit_code = \close!

		if exit_code == 0
			lefttime = battery\match "(%d%d:%d%d:%d%d)"
			status, battery = battery\match "^[^%s]+%s+[^%s]+%s+([^%s,]+).-(%d+)%%"

			if (status == "Discharging") and (tonumber battery) <= percent
				percent = percent == 20 and 10 or -1
				naughty.notify {
					title: "Battery"
					text: "#{battery}% left (#{lefttime})"
					timeout: 10
				}

	with timer timeout: INTERVAL_TIME
		\connect_signal SIG_NAME, battery_alert
		\start!

