local awful = awful or require("awful")
local naughty = naughty or require('naughty')
local screen = awful.screen

local cont = require('cont')
local cont, run, do_ = cont.cont, cont.run, cont.do_

return function(term)
  local t = {
    cmd = term, client = nil, pid = nil,
    properties = nil, show_always = nil,

    default = {
      properties = {
        fullscreen = true,
        hidden = true,
        ontop = true,
        ignore_toggle = true,
        skip_taskbar = true
      },
      show_always = false,
    },

    init = function(self, kglobal)
      local proc = function()
        self.properties = self.default.properties
        self.show_always = self.default.show_always

        local client = cont(function(k)
          return awful.spawn(self.cmd, self.properties, k)
        end)

        self.pid = client.pid
        self.client = client
      end

      if kglobal then
        return run(proc, kglobal)
      else
        return do_(proc)
      end
    end,
    view_toggle = function(self)
      return do_(function()
        if not (self.client and self.client.valid) then
          cont(function(k)
            return self:init(k)
          end)
        end

        local current_screen = screen.focused()
        local current_tag = current_screen.selected_tags[1]
        self.client.fullscreen = true

        if self.client.hidden then
          -- show terminal
          self.client.hidden = false

          if self.show_always then
            self.client.first_tag:view_only()
          else
            self.client:move_to_tag(current_tag)
          end

          client.focus = self.client
          self.client:raise()
        elseif current_tag ~= self.client.first_tag then
          -- go to the tag which has the terminal
          if self.show_always then
            self.client.first_tag:view_only()
          else
            current_tag:view_only()
            self.client:move_to_tag(current_tag)
          end

          client.focus = self.client
          self.client:raise()
        else
          -- hide the terminal
          self.client.hidden = true
        end
      end)
    end,

    show_always_toggle = function(self)
      self.show_always = not self.show_always

      naughty.notify({ preset = naughty.config.presets.normal
                     , title = "DropDownTerminal"
                     , text = ("toggle show_always(%q)"):format(self.show_always)
                     })
    end
  }

  awesome.connect_signal("startup", function() t:init() end)
  awesome.connect_signal("exit", function() if t.client then t.client:kill() end end)

  return t
end

