### Returns all objects within "radius" (default 5000) of the mouse cursor, sorted by nearest
##### Use "sort" if you prefer using class names or something

```
--objects within 10000 radius
OpenExamine(ReturnAllNearby(10000))
--objects within 5000 radius sorted by .class
OpenExamine(ReturnAllNearby(nil,"class"))
```

```
local function ReturnAllNearby(radius,sort)
  radius = radius or 5000
  pos = pos or GetTerrainCursor()

  -- get all objects on map (18K+ on a new map)
  local list = GetObjects{
    -- we only want stuff within *radius*
    filter = function(o)
      if o:GetDist2D(pos) <= radius then
        return o
      end
    end,
  }
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
        return a:GetDist2D(pos) < b:GetDist2D(pos)
      end
    )
  end
  return list
end
```
