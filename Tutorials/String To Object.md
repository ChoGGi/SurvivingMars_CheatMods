### Feed this "Table.Table.Object" and you'll get Object back

```lua
-- use .number for index based tables ("terminal.desktop.1")
function DotNameToObject(str,root,create)

	-- lazy is best
	if type(str) ~= "string" then
		return str
	end
	-- there's always one
	if str == "_G" then
		return _G
	end
	if str == "_ENV" then
		return _ENV
	end

	-- obj always starts out as "root"
	local obj = root or _G

	-- https://www.lua.org/pil/14.1.html
	-- %w is [A-Za-z0-9], [] () + ? . act pretty much like regexp
	local tonumber = tonumber
	for name,match in str:gmatch("([%w_]+)(.?)") do
		-- if str included .number we need to make it a number or [name] won't work
		local num = tonumber(name)
		if num then
			name = num
		end
		-- . means we're not at the end yet
		if match == "." then
			-- create is for adding new settings in non-existent tables
			if not obj[name] and not create then
				-- our treasure hunt is cut short, so return nadda
				return
			end
			-- change the parent to the child (create table if absent, this'll only fire when create)
			obj = obj[name] or {}
		else
			-- no more . so we return as conquering heroes with the obj
			return obj[name]
		end
	end
end
```
