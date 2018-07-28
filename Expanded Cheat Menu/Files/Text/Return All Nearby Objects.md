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
  local pos = GetTerrainCursor()
  --get all objects (18K on a new map)
  local all = GetObjects{}
  --we only want stuff within *radius*
  local list = FilterObjects({
    filter = function(Obj)
      if Obj:GetDist2D(pos) <= radius then
        return Obj
      end
    end
  },all)
  --sort list custom
  if sort then
    table.sort(list,
      function(a,b)
        return a[sort] < b[sort]
      end
    )
  else
    --sort nearest
    table.sort(list,
      function(a,b)
        return a:GetDist2D(pos) < b:GetDist2D(pos)
      end
    )
  end
  return list
end
```
