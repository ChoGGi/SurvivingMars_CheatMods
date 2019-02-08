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

-- if you need a z then you'll need to do a
print(pt:SetZ(
	terrain.GetSurfaceHeight(pt)
))

```
