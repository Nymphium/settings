local wezterm = require("wezterm")

wezterm.GLOBAL.theme = {
	dark = "tokyonight-storm",
	light = "tokyonight-day",
}

local update_window_appearance = function(window)
	local overrides = window:get_config_overrides() or {}
	local appearance = wezterm.gui.get_appearance()
	local scheme
	if appearance:find("Dark") then
		scheme = wezterm.GLOBAL.theme.dark
	else
		scheme = wezterm.GLOBAL.theme.light
	end
	if overrides.color_scheme ~= scheme then
		overrides.color_scheme = scheme
		window:set_config_overrides(overrides)
	end
end

local function update_window_appearance_forever()
	local ok, window = pcall(function()
		return wezterm.gui.get_window()
	end)
	if not ok then
		return
	end

	update_window_appearance(window)

	wezterm.time.call_after(3, update_window_appearance_forever)
end

wezterm.on("mux-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()

	update_window_appearance_forever(window:gui_window())
end)

wezterm.on("window-focus-changed", function(window)
	if window then
		update_window_appearance(window)
	end
end)
