### Returns all objects within "Radius" (default 5000), sorted by nearest
##### sort by class by making Sort "class"

```
--objects within 10000 radius
OpenExamine(ReturnAllNearby(10000)
--objects within 5000 radius sorted by class
OpenExamine(ReturnAllNearby(nil,"class"))
```

```
local function ReturnAllNearby(Radius,Sort)
  Radius = Radius or 5000
  local pos = GetTerrainCursor()
  --we only want stuff within radius
  local all = GetObjects({class="CObject"})
  local list = FilterObjects({
    filter = function(Obj)
      if Obj:GetDist2D(pos) <= Radius then
        return Obj
      end
    end
  },all)
  --sort list
  if Sort then
    table.sort(list,
      function(a,b)
        return a[Sort] < b[Sort]
      end
    )
  else
    table.sort(list,
      function(a,b)
        return a:GetDist2D(pos) < b:GetDist2D(pos)
      end
    )
  end
  return list
end
```
