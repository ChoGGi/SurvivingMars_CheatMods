### Returns either a single colour, or specify an amount to return a table with that many colours
##### Just over 500 ticks to generate 5 tables of 100K colours each, 1 table of 1M colours takes just under 2000 ticks


```
--returns a colour
RandomColour()
--returns an index based table with a thousand colours
RandomColour(1000)
```

```
-- helper functions for RandomColour function (below)
local function RetTableNoDupes(list)
	local temp_t = {}
	local dupe_t = {}
	local c = 0

	for i = 1, #list do
		if not dupe_t[list[i]] then
			c = c + 1
			temp_t[c] = list[i]
			dupe_t[list[i]] = true
		end
	end

	return temp_t
end
-- m = min, n = max
local AsyncRand = AsyncRand
local function Random(m, n)
	return AsyncRand(n - m + 1) + m
end

function RandomColour(amount)
	if amount and type(amount) == "number" then

		local colours = {}
		local c = 0
		-- populate list with amount we want
		for _ = 1, amount do
			c = c + 1
			colours[c] = Random(-16777216,0) -- 24bit colour
		end

		-- now remove all dupes and add more till we hit amount
		repeat
			-- then loop missing amount
			c = #colours
			for _ = 1, amount - #colours do
				c = c + 1
				colours[c] = Random(-16777216,0)
			end
			-- remove dupes
			colours = RetTableNoDupes(colours)
		until #colours == amount

		return colours
	end

	-- return a single colour
	return Random(-16777216,0)

end
```
