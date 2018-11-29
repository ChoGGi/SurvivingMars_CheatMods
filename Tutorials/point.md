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

-- if you need a z then you'll need to do a
local z_pt = point(pt:x(),pt:y(),terrain.GetSurfaceHeight(pt))
print(z_pt)

```
