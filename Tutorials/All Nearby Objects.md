### Returns all objects within "radius" (default 5000) of the mouse cursor, sorted by nearest
##### Use "sort" if you prefer using class names or something

```lua
-- objects within 10000 radius
OpenExamine(ReturnAllNearby(10000))
-- objects within 5000 radius sorted by .class
OpenExamine(ReturnAllNearby(nil,"class"))
```

```lua
function ReturnAllNearby(radius,sort,pt)
	radius = radius or 5000
	pt = pt or GetTerrainCursor()

	-- get all objects within radius
	local list = MapGet(pt,radius)

	-- sort list custom
	if sort then
		table.sort(list,
			function(a,b)
				return a[sort] < b[sort]
			end
		)
	else
		-- sort nearest
		table.sort(list,
			function(a,b)
				return a:GetVisualDist(pt) < b:GetVisualDist(pt)
			end
		)
	end

	return list
end
```
