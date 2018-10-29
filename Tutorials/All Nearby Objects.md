### Returns all objects within "radius" (default 5000) of the mouse cursor, sorted by nearest
##### Use "sort" if you prefer using class names or something

```
-- objects within 10000 radius
OpenExamine(ReturnAllNearby(10000))
-- objects within 5000 radius sorted by .class
OpenExamine(ReturnAllNearby(nil,"class"))
```

```
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
				return a:GetDist2D(pt) < b:GetDist2D(pt)
			end
		)
	end

	return list
end
```
