### Returns either a single colour, or specify an amount to return a table with that many colours


```
--returns a colour
RandomColour()
--returns an index based table with a thousand colours
RandomColour(1000)
```

```
local function RetTableNoDupes(list)
  local tempt = {}
  local dupe = {}

  for i = 1, #list do
    if not dupe[list[i]] then
      tempt[#tempt+1] = list[i]
      dupe[list[i]] = true
    end
  end
  return tempt
end

local RandColor = RandColor
function RandomColour(amount)
  -- amount isn't a number so return a single colour
  if type(amount) ~= "number" then
    return RandColor() --24bit colour
  end

  local colours = {}
  -- populate list with amount we want
  for _ = 1, amount do
    colours[#colours+1] = RandColor()
  end

  -- now remove all dupes and add more till we hit amount
  while #colours ~= amount do
    -- remove dupes
    colours = RetTableNoDupes(colours)
    -- then loop missing amount
    for _ = 1, amount - #colours do
      colours[#colours+1] = RandColor()
    end
  end

  return colours
end
```
