### Feed this "Table.Table.Object" and you'll get Object back.

##### use .number for index based tables DotNameToObject("terminal.desktop.1.box")

```lua
-- local some globals for that extra bit 'o speed
local type,tonumber,rawget = type,tonumber,rawget

-- root is where we start looking (defaults to _G).
-- create is a boolean to add a table if the dotname is absent.
function DotNameToObject(str,root,create)

	-- lazy is best
	if type(str) ~= "string" then
		return str
	end

	local g = _G
	-- there's always one
	if str == "_G" then
		return g
	end
	if str == "_ENV" then
		return _ENV
	end

	-- parent always starts out as "root"
	local parent = root or g

	-- https://www.lua.org/pil/14.1.html
	-- %w is [A-Za-z0-9], [] () + ? . act like regexp (lua patterns)
	for name,match in str:gmatch("([%w_]+)(.?)") do
		-- if str included .number we need to make it a number or [name] won't work
		local num = tonumber(name)
		if num then
			name = num
		end

		local obj_child
		if parent == g then
			-- SM error spams console if you have the affront to try _G.NonExistingKey... (thanks autorun.lua)
			-- it works prefectly fine of course, but i like a clean log.
			-- in other words a workaround for "Attempt to use an undefined global '"
			obj_child = rawget(parent,name)
		else
			obj_child = parent[name]
		end

		-- . means we're not at the end yet
		if match == "." then
			-- create is for adding new settings in non-existent tables
			if not obj_child and not create then
				-- our treasure hunt is cut short, so return nadda
				return
			end
			-- change the parent to the child (create table if absent, this'll only fire when create)
			parent = obj_child or {}
		else
			-- no more . so we return as conquering heroes with the obj
			return obj_child
		end
	end
end
```
