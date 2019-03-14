### point object stuff

```lua
to compare points use tostring.
local pt1 = point(0,0)
local pt2 = point(0,0)

-- prints false
print(pt2 == pt2)
-- prints true
print(tostring(pt1) == tostring(pt2))
-- point objects are userdata, so unless it's the same userdata object == won't work.
```

### Get a random nearby passable point from a point
```lua
local function RetRand(min,max)
	return AsyncRand(max - min + 1) + min
end
-- some point to use
local pt = GetTerrainCursor()
-- min/max dist away
local min = -1000
local max = 1000

pt = GetPassablePointNearby(point(
	pt:x()+Random(min,max),
	pt:y()+Random(min,max)
))
print(pt)

-- there's also
-- GetRandomPassable()
-- GetRandomPassableAround(pt, 100 * guim)

-- if you want a z then you'll need to do a
print(pt:SetTerrainZ())
-- or
print(pt:SetZ(
	terrain.GetSurfaceHeight(pt)
))
```
