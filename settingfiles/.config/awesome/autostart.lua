local awful = awful or require('awful')
local autostart = {}

--[[ autostart config file syntax:
typ command
typ command
......

typ: [o]neshot   as daemon, simple oneshot command
	 [e]verytime as everytime run(nable) command
	 --]]

function autostart.read(filepath)
	if not filepath:match('^/') then
		filepath = awful.util.get_configuration_dir() .. filepath
	end

	local file = io.open(filepath)

	local t = {}
	local linenr = 0

	for line in file:lines() do
		linenr = linenr + 1

		if not (line:match('^%s*#') or line:match('^%s*$')) then
			local typ, cmd = line:match('^%s*([oaOA])%s+(.+)$')

			if not typ:match('^[oaOA]$') then
				error(([=[type must be [o]neshot or [everytime (got `%s' at line %d)]]=]):format(typ, linenr))
			end

			table.insert(t, {typ, cmd})
		end
	end

	file:close()

	local aligned = {
		oneshot = {},
		anytime = {}
	}

	for i = 1, #t do
		if t[i][1] == 'o' then
			table.insert(aligned.oneshot, t[i][2])
		else
			table.insert(aligned.anytime, t[i][2])
		end
	end

	return aligned
end

local function spawn_oneshot(cmd)
	awful.spawn.easy_async_with_shell(([=[[ ! $(pgrep %s) ] && %s]=]):format(cmd, cmd))
end

setmetatable(autostart, {
			 __call = function(self, filepath)
				 local cont = self.read(filepath)
				 local oneshot, anytime = cont.oneshot, cont.anytime

				 self.oneshot = oneshot
				 self.anytime = anytime

				 for i = 1, #oneshot do
					 spawn_oneshot(oneshot[i])
				 end

				 for i = 1, #anytime do
					 awful.spawn.easy_async_with_shell(anytime[i])
				 end
			 end
		 })

return autostart

