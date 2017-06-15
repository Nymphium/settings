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

function autostart.run(cmds)
	for i = 1, #cmds do
		awful.util.spawn_with_shell(cmds[i])
	end
end

setmetatable(autostart, {
			 __call = function(self, filepath)
				 local cont = self.read(filepath)

				 self.run(cont.oneshot)
				 self.run(cont.anytime)
			 end
		 })

return autostart

