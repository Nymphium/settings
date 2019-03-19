local awful = awful or require("awful")
local screen = awful.screen

return function(term)
	local t = {
		cmd = term, client = nil, pid = nil,
		properties = {
			fullscreen = true,
			hidden = true,
			ontop = true,
			skip_taskbar = true
		},
		show_always = false,

		-- methods
		get = function(self)
			for _, c in pairs(client.get()) do
				if c.pid == self.pid then
					return c
				end
			end
		end,
		set = function(self)
			local c = self:get()

			if not c then
				self.pid = awful.spawn(self.cmd, self.properties)

				c = self:get()
			end

			self.client = c
		end,
		view_toggle = function(self)
			return function()
				if not (self.client and self.client.valid) then
					self:set()
					return
				end

				local current_screen = screen.focused()
				local current_tag = current_screen.selected_tags[1]

				if self.client.hidden then
					self.client.hidden = false
					if not self.show_always then
						self.client:move_to_tag(current_tag)
						client.focus = self.client
						self.client:raise()
						self.client.fullscreen = false
						self.client.fullscreen = true
					else
						self.client.first_tag:view_only()
						self.client:raise()
					end
					client.focus = self.client
				elseif current_tag ~= self.client.first_tag then
					if not self.show_always then
						current_tag:view_only()
						self.client:move_to_tag(current_tag)
					end

					client.focus = self.client
				else
					self.client.hidden = true
				end
			end
		end,
		show_always_toggle = function(self)
			return function()
				self.show_always = not self.show_always
			end
		end
	}

	awesome.connect_signal("startup", function() t:set() end)
	awesome.connect_signal("exit", function() if t.client then t.client:kill() end end)

	return t
end

