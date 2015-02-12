local awful = require("awful")

local function getwindowsize(c)
	local c = c or client.focus
	local full_state = 1

	if not c.fullscreen then
		c.fullscreen = not c.fullscreen
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


local myfunc = {}
function myfunc.domyconf(file)
	file = awful.util.getdir("config") .. "/" .. file

	if io.open(file) then
		dofile(file)
		io.close(file)
	end
end

function myfunc.lifting(c)
	if c.fullscreen then c.fullscreen = not c.fullscreen end
	if c.maximized_vertical then c.maximized_vertical = not c.maximized_vertical end
	if c.maximized_horizontal then c.maximized_horizontal = not c.maximized_horizontal end
end

function myfunc.setwindowsize(direction)
	local c = client.focus
	-- if c.fullscreen or c.maximized_vertical or c.maximized_horizontal then return end

	local geom = c:geometry()
	local h, w = getwindowsize(c)
	h = h / 20
	w = w / 20

	if direction == "l" then
		geom.width = geom.width + w
		elseif direction == "k" then
			geom.height = geom.height + h
			elseif direction == "j" then
				geom.height = geom.height - h
				elseif direction == "h" then
					geom.width = geom.width - w
				end
			end

			return myfunc

