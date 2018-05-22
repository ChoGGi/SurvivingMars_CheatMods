### Returns all objects within "Radius" (default 5000), sorted by nearest
##### sort by class by making Sort "class"

```
--returns a colour
RandomColour()
--returns a numbered table with a thousand colours
RandomColour(1000)
```

```
local function RetTableNoDupes(Table)
  local tempt = {}
  local dupe = {}

  for i = 1, #Table do
    if not dupe[Table[i]] then
      tempt[#tempt+1] = Table[i]
      dupe[Table[i]] = true
    end
  end
  return tempt
end

local function RandomColour(Amount)
  local AsyncRand = AsyncRand

  --no amount return single colour
  if type(Amount) ~= "number" then
    return AsyncRand(16777216) * -1
  end
  local randcolors = {}
  --populate list with amount we want
  for _ = 1, Amount do
    randcolors[#randcolors+1] = AsyncRand(16777216) * -1
  end
  --now remove all dupes and add more till we hit amount
  while true do
    --loop missing amount
    for _ = 1, Amount - #randcolors do
      randcolors[#randcolors+1] = AsyncRand(16777216) * -1
    end
    --then remove dupes
    randcolors = RetTableNoDupes(randcolors)
    if #randcolors == Amount then
      break
    end
  end
  return randcolors
end
```
