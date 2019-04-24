### Feed this "Table.Table.Object" and you'll get Object back.

##### use .number for index based tables DotNameToObject("terminal.desktop.1.box")
##### spaces and whatnot are fine to use (pretty much anything but a .)

```lua
-- local some globals for that extra bit 'o speed
local type,tonumber,rawget = type,tonumber,rawget

local g

-- root is where we start looking (defaults to _G).
-- create is a boolean to add a table if the dotname is absent.
function DotNameToObject(str,root,create)
	g = g or _G

	-- parent always starts out as "root"
	local parent = root or g

	-- https://www.lua.org/pil/14.1.html
	-- [] () + ? . act like regexp ones
	-- % escape special chars
	-- ^ complement of the match (the "opposite" of the match)
	for name,match in str:gmatch("([^%.]+)(.?)") do
		-- if str included .number we need to make it a number or [name] won't work
		local num = tonumber(name)
		if num then
			name = num
		end

		local obj_child
		-- workaround for "Attempt to use an undefined global"
		if parent == g then
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
