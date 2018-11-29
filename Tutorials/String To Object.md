### Feed this "Table.Table.Object" and you'll get Object back

```lua
-- DotNameToObject("some.some.some.etc") returns etc as object
function DotNameToObject(str,root,create)
	-- always start with _G
	local obj = root or _G
	-- https://www.lua.org/pil/14.1.html
	for name,match in str:gmatch("([%w_]+)(.?)") do
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
