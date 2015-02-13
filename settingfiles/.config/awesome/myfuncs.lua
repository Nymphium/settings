local awful = require("awful")


local myfuncs = {}

function myfuncs.domyconf(file)
	file = awful.util.getdir("config") .. "/" .. file
	local posix = require("posix")

	if posix.stat(file) then
		dofile(file)
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

function myfuncs.getwindowsize(full)
	local c = client.focus
	local full_state = full or 0

	if not c.fullscreen then
		myfuncs.toggle("f")
		full_state = 0
	end
	
	local geom = c:geometry()

	local h = geom.height
	local w = geom.width

	if full_state < 1 then
		c.fullscreen = not c.fullscreen
	end

	return h, w
end

function myfuncs.lifting()
	local c = client.focus
	if c.fullscreen then myfuncs.toggle("f") end
	if c.maximized_vertical then myfuncs.toggle("v") end
	if c.maximized_horizontal then myfuncs.toggle("h") end
end

function myfuncs.setwindowsize(direction, pos)
	local c = client.focus

	if c.fullscreen
		or c.maximized_vertical
		or c.maximized_horizontal then
		return
	end

	local pos = pos or nil
	local _x = pos and "x" or "width"
	local _y = pos and "y" or "height"


	local geom = c:geometry()
	local h, w = myfuncs.getwindowsize()
	h = h / 20
	w = w / 20

	local tip_h = geom.height % h
	local tip_w = geom.width % w
	if tip_w > 0 then geom.width = geom.width + w - tip_w end
	if tip_h > 0 then geom.height = geom.height + h - tip_h end

	if direction == "l" then
		geom[_x] = geom[ _x ] + w
	elseif direction == "k" then
		geom[_y] = geom[_y] - h
	elseif direction == "j" then
		geom[_y] = geom[_y] + h
	elseif direction == "h" then
		geom[_x] = geom[_x] - w
	end

	c:geometry(geom)
end

function myfuncs.halfsize(rl)
	local c = client.focus

	if c.fullscreen then
		myfuncs.toggle("f")
	end

	if c.maximized_vertical then
		myfuncs.toggle("v")
	end

	if c.maximized_horizontal then
		myfuncs.toggle("h")
	end

	myfuncs.toggle("vh")

	local geom = c:geometry()
	geom.width = geom.width / 2
	if rl:find("l") then geom.x = geom.width end

	myfuncs.toggle("vh")
	c:geometry(geom)
end


return myfuncs

