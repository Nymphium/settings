local wezterm = require("wezterm")

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

local sections = {
	tabline_a = { "mode" },
	tabline_b = { "domain" },
	tab_active = {
		" ",
		{ "zoomed", padding = 0 },
		-- { 'index',   padding = 0 },
		{ "process", padding = 0 },
		"|",
		{ "cwd", padding = 0 },
		" ",
	},
	tab_inactive = {
		{ "index", padding = 0 },
		"cwd",
	},

	tabline_y = { "battery" },
	tabline_z = {},
}

if not wezterm.GLOBAL.windows then
	sections.tabline_x = { "ram" }
end

tabline.setup({
	sections = sections,
})

local update_tab_appearance = function()
	if not wezterm.gui then
		return
	end

	local appearance = wezterm.gui.get_appearance()
	local theme
	if appearance:find("Dark") then
		theme = wezterm.GLOBAL.theme.dark
	else
		theme = wezterm.GLOBAL.theme.light
	end
	tabline.set_theme(theme)
end

local function update_tab_appearance_forever()
	update_tab_appearance()

	return wezterm.time.call_after(3, update_tab_appearance_forever)
end

wezterm.on("mux-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()

	update_tab_appearance_forever()
end)

wezterm.on("window-focus-changed", function(window)
	if window then
		update_tab_appearance()
	end
end)

wezterm.on("window-config-reloaded", function(window)
	if window then
		update_tab_appearance()
	end
end)

return {
	detect_dark_mode = update_tab_appearance,
}
