### Returns either a single colour, or specify an amount to return a table with that many colours (no dupes)
##### Around 325 ticks to generate 1 table of 1M colours

```lua
-- returns single colour
RandomColour()
-- returns an index based table with a thousand colours
RandomColour(1000)
```

```lua
-- local instead of global lookup is slightly faster
local table_clear = table.clear
local AsyncRand = AsyncRand

function RandomColour(amount)
	if amount and type(amount) == "number" and amount > 1 then
		-- temp associative table of colour ids
		table_clear(color_ass)
		-- indexed list of colours we return
		local colour_list = {}
		-- when this reaches amount we return the list
		local c = 0
		-- loop through the amount once
		for i = 1, amount do
			-- 16777216: https://en.wikipedia.org/wiki/Color_depth#True_color_(24-bit)
			-- we skip the alpha values
			local colour = AsyncRand(16777217) + -16777216
			if not color_ass[colour] then
				color_ass[colour] = true
				c = c + 1
			end
		end
		-- then make sure we're at count (
		while c < amount do
			local colour = AsyncRand(16777217) + -16777216
			if not color_ass[colour] then
				color_ass[colour] = true
				c = c + 1
			end
		end
		-- convert ass to idx list
		c = 0
		for colour in pairs(color_ass) do
			c = c + 1
			colour_list[c] = colour
		end

		return colour_list
	end

	-- return a single colour
	return AsyncRand(16777217) + -16777216
end
```
