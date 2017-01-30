local awful = awful or require('awful')
local theme = theme
do
	-- local function systray_init()
		local _with_0 = awful.util
		_with_0.spawn("pkill ibus-ui-gtk3")
		_with_0.spawn_with_shell("pgrep nm-applet || nm-applet &")
		_with_0.spawn_with_shell("pgrep dropbox || dropbox &")
		_with_0.spawn_with_shell("nvidia-settings --load-config-only")

		-- awesome.disconnect_signal("systray::init", systray_init)
	-- end

	-- awesome.connect_signal("systray::init", systray_init)
end
do
  -- package.path = package.path .. ";/home/nymphium/.luarocks/share/lua/5.3/?.lua;/home/nymphium/.luarocks/share/lua/5.3/?/init.lua;/usr/share/lua/5.3/?.lua;/usr/share/lua/5.3/?/init.lua;/usr/lib/lua/5.3/?.lua;/usr/lib/lua/5.3/?/init.lua;./?.lua;./?/init.lua;;"
  local naughty = naughty or require('naughty')
  local timer = timer or require('timer')
  local tsig = "timeout"
  if pcall(require, 'luakatsu') then
    local oiwai
    oiwai = function()
      local today = os.date("*t")
      do
        today.md = ("%02d/%02d"):format(today.month, today.day)
      end
      do
        local idol = Aikatsu:find_birthday(today.md)
        if idol then
          return naughty.notify((function()
            do
              local msg = {
                title = tostring(today.month) .. " がつ " .. tostring(today.day) .. " にち",
                text = "今日は" .. tostring(idol.name) .. "ちゃんのお誕生日だよ!",
                height = 50,
                timeout = 10,
                fg = "ff0000",
                bg = "ffff00",
                run = function(n)
                  awful.util.spawn("xdg-open https://twitter.com/intent/tweet?text=" .. tostring(idol.name:gsub("%s", "+")) .. "ちゃん誕生日おめでとう!")
                  return naughty.destroy(n)
                end
              }
              msg.width = (theme.font:match("%d+") * 0.5) * msg.text:len()
              return msg
            end
          end)())
        end
      end
    end
    local luakatsutimer
    do
      local _with_0 = timer({
        timeout = 21600
      })
      _with_0:connect_signal(tsig, oiwai)
      luakatsutimer = _with_0
    end
    local now, sec = os.date("*t")
    do
      sec = (now.hour * 60 + now.min) * 60 + now.sec
    end
    if sec < 21600 then
      sec = 21600 - sec
    elseif sec < 43200 then
      sec = 43200 - sec
    elseif sec < 64800 then
      sec = 64800 - sec
    elseif sec < 86400 then
      sec = 86400 - sec
    end
    oiwai()
    local padding
    padding = function(timer)
      return function(self)
        self:stop()
        return timer:start()
      end
    end
    local paddingtimer
    do
      local _with_0 = timer({
        timeout = sec
      })
      _with_0:connect_signal(tsig, padding(luakatsutimer))
      _with_0:start()
      paddingtimer = _with_0
    end
  end
end
