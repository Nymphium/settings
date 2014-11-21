local posix = require("posix")


local function printf(...)
	io.write(string.format(...))
end

local function is_executable(exec)
	local handle = io.popen(exec)

	local result = handle:read("*a")

	handle:close()

	return #result > 0 and true or false
end


local path = posix.realpath("./statuslines")

local ls = posix.dir(path)

local ls_out = {}

for _, i in pairs(ls) do
	if (i ~= ".") and (i ~= "..") then
		table.insert(ls_out, i)
	end
end

local bright, dark  = 239, 235

printf("\"#[bg=colour%d,fg=colour27,bold]⇛#(echo $USER)@#H #[fg=colour75, bg=colour239] %%Y/%%m/%%d(%%a)%%H:%%M ", dark)

table.sort(ls_out)

local k = 0

for _, i in pairs(ls_out) do
	if is_executable(path .. "/" .. i) then
		local color = k % 2 ~= 0 and bright or dark

		printf("#[bg=colour%d] #(%s/%s) ", color, path, i)
	
		k = k + 1
	end
end

local color = k % 2 ~= 0 and bright or dark

printf("#[bg=colour%d] #{session_windows} windows %%\"", color)

