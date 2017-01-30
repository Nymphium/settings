local awful = require("awful")
local myfuncs = {}

local function screen_size(screen)
	local geom = screen.geometry

	return geom.width, geom.height
end

function myfuncs.domyconf(file)
	file = awful.util.getdir("config") .. "/" .. file

	if awful.util.checkfile(file) then
		in_error = pcall(dofile, file)
	end
end

function myfuncs.toggle(fvh, c)
	local c = c or client.focus
	local fvh = fvh or "fvh"

	if fvh:find("f") then
		c.fullscreen = not c.fullscreen
	end

	if fvh:find("v") then
		c.maximized_vertical = not c.maximized_vertical
	end

	if fvh:find("h") then
		c.maximized_horizontal = not c.maximized_horizontal
	end
end

function myfuncs.setwindowsize(direction, pos)
	local c = client.focus

	if c.fullscreen or c.maximized_vertical or c.maximized_horizontal then
		return
	end

	local x = pos and "x" or "width"
	local y = pos and "y" or "height"
	local geom = c:geometry()
	local w, h = screen_size(c.screen)

	h = h / 20
	w = w / 20

	local tip_h = geom.height % h
	local tip_w = geom.width % w

	if tip_w > 0 then geom.width = geom.width + w - tip_w end
	if tip_h > 0 then geom.height = geom.height + h - tip_h end

	if direction == "l" then
		geom[x] = geom[x] + w
	elseif direction == "k" then
		geom[y] = geom[y] - h
	elseif direction == "j" then
		geom[y] = geom[y] + h
	elseif direction == "h" then
		geom[x] = geom[x] - w
	end

	c:geometry(geom)
end

function myfuncs.halfsize(rl)
	local c = client.focus

	if c.fullscreen then
		myfuncs.toggle("f")
	end

	if not c.maximized_vertical then
		myfuncs.toggle("v")
	end

	if not c.maximized_horizontal then
		myfuncs.toggle("h")
	end

	local geom = c:geometry()
	geom.width = geom.width / 2

	if rl:find("l") then
		geom.x = geom.width
	end

	myfuncs.toggle("vh")

	c:geometry(geom)
end

function myfuncs.squaresize(c)
	c = c or client.focus
	
	if not c then
		return
	end

	local geom = c:geometry()
	local x, y = geom.x, geom.y
	local w, h = screen_size(c.screen)
	c.maximized_vertical = false
	c.maximized_horizontal = false
	geom.height = h / 2
	geom.width = w / 2
	geom.x = x
	geom.y = y

	c:geometry(geom)
end

return myfuncs

