local awful = awful or require'awful'
local shortcuts = {}

--[==[shortcuts syntax
MODIFLER MODIFIER ..., KEY | KEY
	command | lua: BODY

MODIFLER MODIFIER ..., KEY | KEY
	command | lua: BODY
......

--[[
MODIFIER can Be contained `mod` as the modifier key
BODY is registered as `function(c) BODY end` so BODY can use `c` which is current focused client
--]]
--]==]

function shortcuts.read(filepath)
	if not filepath:match('^/') then
		filepath = awful.util.get_configuration_dir() .. filepath
	end

	local file = io.open(filepath)
	local t = {}
	local linenr = 0

	for line in file:lines() do
		if not (line:match('^%s*#') or line:match('^%s*$')) then
			linenr = linenr + 1

			if linenr % 2 == 1 then
				table.insert(t, {line})
			else
				local luafn = line:match('^%s*lua:%s*(.+)$')

				if luafn then
					table.insert(t[linenr//2], load(('return function(c) %s end'):format(luafn))())
				else
					table.insert(t[linenr//2], line)
				end
			end
		end
	end

	return t
end

local function split(s)
	local tbl = {}

	for w in s:gmatch('(%S+)%s*') do
		table.insert(tbl, w)
	end

	return tbl
end

local function compile_key(k)
	local mods, ch = k:match('^%s*(.*),%s*(.+)%s*$')

	if not ch then
		if k:match('%S%s+%S') or k:match(',') then
			error('invalid syntax: `' .. k .. "'")
		end

		return {}, k
	end

	mods = split(mods)

	for i = 1, #mods do
		if mods[i] == "mod" then
			mods[i] = modkey
		end
	end

	return mods, ch
end

function shortcuts.register(keys, tbl)
	for i = 1, #tbl do
		local mods, ch = compile_key(tbl[i][1])
		local action = tbl[i][2]

		if type(action) == "function" then
			keys = awful.util.table.join(keys, awful.key(mods, ch, action))
		else
			keys = awful.util.table.join(keys, awful.key(mods, ch, function() awful.util.spawn_with_shell(action) end))
		end
	end

	root.keys(keys)
end

setmetatable(shortcuts, {
			 __call = function(self, keys, path)
				 self.register(keys, self.read(path))
			 end
		 })

return shortcuts

