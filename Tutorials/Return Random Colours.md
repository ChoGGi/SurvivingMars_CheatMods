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

  for i = 1, #list do
    if not dupe_t[list[i]] then

      temp_t[#temp_t+1] = list[i]
      dupe_t[list[i]] = true

    end
  end

  return temp_t
end
local function Random(m, n)
  if n then
    -- m = min, n = max
    return AsyncRand(n - m + 1) + m
  else
    -- m = max, min = 0 OR number between 0 and max_int
    return m and AsyncRand(m) or AsyncRand()
  end
end

function RandomColour(amount)
  if amount and type(amount) == "number" then

    local colours = {}
    -- populate list with amount we want
    for _ = 1, amount do
      colours[#colours+1] = Random(-16777216,0) -- 24bit colour
    end

    -- now remove all dupes and add more till we hit amount
    repeat
      -- then loop missing amount
      for _ = 1, amount - #colours do
        colours[#colours+1] = Random(-16777216,0)
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
