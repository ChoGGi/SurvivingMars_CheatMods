### Returns either a single colour, or specify an amount to return a table with that many colours (no dupes)
##### Around 400 ticks to generate 5 tables of 100K colours each, and around 1100 for 1 table of 1M colours

```lua
-- returns single colour
RandomColour()
-- returns an index based table with a thousand colours
RandomColour(1000)
```

```lua
-- local instead of global lookup is slightly faster
local table_find = table.find
local table_clear = table.clear
local table_iclear = table.iclear
local AsyncRand = AsyncRand

-- helper function
local dupe_t = {}
local temp_t = {}
local function TableCleanDupes(list)
	-- quicker to make a new list on large tables
	if #list > 10000 then
		dupe_t = {}
		temp_t = {}
	else
		table_clear(dupe_t)
		table_iclear(temp_t)
	end

	local c = 0
	for i = 1, #list do
		if not dupe_t[list[i]] then
			c = c + 1
			temp_t[c] = list[i]
			dupe_t[list[i]] = true
		end
	end

	table_iclear(list)
	for i = 1, #temp_t do
		list[i] = temp_t[i]
	end

	return list
end

function RandomColour(amount)
	if amount and type(amount) == "number" then
		-- somewhere to store the colours
		local colour_list = {}
		-- populate list with amount we want
		for i = 1, amount do
			-- 16777216: https://en.wikipedia.org/wiki/Color_depth#True_color_(24-bit)
			-- kinda, we skip the alpha values
			colour_list[i] = AsyncRand(16777217) + -16777216
		end

		-- now remove all dupes and add more till we hit amount
		local c
		-- we use repeat instead of while, as this checks at the end instead of beginning (ie: after we've removed dupes once)
		repeat
			c = #colour_list
			-- loop missing amount
			for _ = 1, amount - #colour_list do
				c = c + 1
				colour_list[c] = AsyncRand(16777217) + -16777216
			end
			-- remove dupes (it's quicker to do this then check the table for each newly added colour)
			TableCleanDupes(colour_list)
		-- once we're at parity then off we go
		until #colour_list == amount

		return colour_list
	end

	-- return a single colour
	return AsyncRand(16777217) + -16777216
end
```
