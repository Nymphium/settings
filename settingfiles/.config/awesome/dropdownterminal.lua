local awful = awful or require("awful")
local screen = awful.screen

local eff = require('eff')
local perform, handlers, inst = eff.perform, eff.handlers, eff.inst

local Await = inst()
local await = function(f)
	return perform(Await(f))
end

local do_await = function(body, k)
	return handlers{
		k,
		[Await] = function(k, f)
			return f(k)
		end
	}(body)
end

local imperative = handlers {
	function(x) return x end,
	[Await] = function(k, f)
		return f(k)
	end
}

return function(term)
	local t = {
		cmd = term, client = nil, pid = nil,
		properties = {
			fullscreen = true,
			hidden = true,
			ontop = true,
			ignore_toggle = true,
			skip_taskbar = true
		},
		show_always = false,

		init = function(self, k)
			return do_await(function()
				local client = await(function(k)
					return awful.spawn(self.cmd, self.properties, k)
				end)

				self.pid = client.pid
				self.client = client
			end, k)
		end,
		view_toggle = function(self)
			return imperative(function()
				if not (self.client and self.client.valid) then
					await(function(k)
						return self:init(k)
					end)
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
			end)
		end,

		show_always_toggle = function(self)
			self.show_always = not self.show_always
		end
	}

	awesome.connect_signal("startup", function() t:init() end)
	awesome.connect_signal("exit", function() if t.client then t.client:kill() end end)

	return t
end

