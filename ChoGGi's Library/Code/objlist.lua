function IsObjlist(list)
	return type(list) == "table" and getmetatable(list) == objlist
end

function IsOldObjListType(o)
  if type(o) ~= "table" or IsValid(o) then
    return false
  end
  if #o == 0 then
    return true
  end
  return o[1] and IsValid(o[1])
end
function table.validate(t)
  for i = #t, 1, -1 do
    if not IsValid(t[i]) then
      table.remove(t, i)
    end
  end
  return t
end
function ObjectsAveragePos(obj_list)
  local count, center, error
  local invalid_pos = InvalidPos()
  for i = 1, #obj_list do
    local pos = obj_list[i]:GetPos()
    if pos ~= invalid_pos then
      if count then
        count = count + 1
        local v = pos - center + error
        center = center + v / count
        error = v % count
      else
        count = 1
        center = pos
        error = point30
      end
    end
  end
  if count then
    return center + 2 * error / count
  else
    return invalid_pos
  end
end
objlist = rawget(_G, "objlist") or {}
for k in pairs(objlist) do
  objlist[k] = nil
end
local IsLuaObject = function(o)
  if type(o) == "table" then
    return not not o.class
  end
  return false
end
local IsObjClass = function(o)
  if type(o) == "string" then
    return not not g_Classes[o]
  end
  return false
end
function objlist:new(o)
  if IsObjlist(o) then
    local o1 = table.icopy(o)
    setmetatable(o1, self)
    return o1
  else
    o = o or {}
    setmetatable(o, self)
    return o
  end
end
function objlist:Count()
  return #self
end
function objlist:Shuffle(func)
  return table.shuffle(self, func)
end
function objlist:Find(o)
  for index = 1, #self do
    if o == self[index] then
      return index
    end
  end
  return nil
end
function objlist:Remove(o)
  if IsLuaObject(o) then
    for i = #self, 1, -1 do
      if self[i] == o then
        table.remove(self, i)
      end
    end
  elseif IsObjlist(o) then
    local used = {}
    for idx = 1, #o do
      used[o[idx]] = true
    end
    for i = #self, 1, -1 do
      if used[self[i]] then
        table.remove(self, i)
      end
    end
  elseif type(o) == "function" then
    for i = #self, 1, -1 do
      if o(self[i]) then
        table.remove(self, i)
      end
    end
  else
    for i = #self, 1, -1 do
      if self[i]:IsKindOf(o) then
        table.remove(self, i)
      end
    end
  end
end
function objlist:Reverse()
  local size = #self
  for i = 1, size / 2 do
    self[i], self[size - i + 1] = self[size - i + 1], self[i]
  end
end
function objlist:Contains(o)
  if type(o) == "string" then
    for idx = 1, #self do
      if self[idx]:IsKindOf(o) then
        return true
      end
    end
  elseif IsLuaObject(o) then
    for idx = 1, #self do
      if self[idx] == o then
        return true
      end
    end
  elseif IsObjlist(o) then
    local used = {}
    for idx = 1, #self do
      used[self[idx]] = true
    end
    for idx = 1, #o do
      if not used[o[idx]] then
        return false
      end
    end
    return true
  end
  return false
end
function objlist:PushFront(o)
  if IsObjlist(o) then
    local size = #self
    local n = #o
    for i = size, 1, -1 do
      self[i + n] = self[i]
    end
    for i = 1, n do
      self[i] = o[i]
    end
  else
    table.insert(self, 1, o)
  end
end
function objlist:PushBack(o)
  if IsObjlist(o) then
    local size = #self
    local n = #o
    for i = 1, n do
      self[size + i] = o[i]
    end
  else
    self[#self + 1] = o
  end
end
function objlist:Clear()
  table.iclear(self)
end
function objlist:Union(o)
  local used = {}
  local union = objlist:new({})
  for i = 1, #self do
    local obj = self[i]
    if not used[obj] then
      table.insert(union, obj)
      used[obj] = true
    end
  end
  for i = 1, #o do
    local obj = o[i]
    if not used[obj] then
      table.insert(union, obj)
      used[obj] = true
    end
  end
  return union
end
function objlist.UnionMultiple(lists)
  local used = {}
  local union = objlist:new({})
  for i = 1, #lists do
    local o = lists[i]
    for i = 1, #o do
      local obj = o[i]
      if not used[obj] then
        table.insert(union, obj)
        used[obj] = true
      end
    end
  end
  return union
end
function objlist:Intersection(o)
  local used = {}
  for i = 1, #o do
    used[o[i]] = true
  end
  local intersect = objlist:new({})
  for i = 1, #self do
    local obj = self[i]
    if used[obj] then
      used[obj] = false
      table.insert(intersect, obj)
    end
  end
  return intersect
end
function objlist:Subtraction(o)
  local used = {}
  for i = 1, #o do
    used[o[i]] = true
  end
  local sub = objlist:new({})
  for i = 1, #self do
    local obj = self[i]
    if not used[obj] then
      used[obj] = true
      table.insert(sub, obj)
    end
  end
  return sub
end
function objlist:Sub(first, last)
  first = first or 1
  last = last or #self
  local res = objlist:new({})
  if first > last then
    return res
  end
  for i = first, last do
    table.insert(res, self[i])
  end
  return res
end
function objlist:FindMin(f)
  local min, value, value2, idx
  for i = 1, #self do
    local obj = self[i]
    local v, v2 = f(obj)
    if v and (not min or value > v) then
      min = obj
      value = v
      idx = i
      value2 = v2
    end
  end
  return min, value, value2, idx
end
function objlist:FindMax(f)
  local max, value, value2, idx
  for i = 1, #self do
    local obj = self[i]
    local v, v2 = f(obj)
    if v and (not max or value < v) then
      max = obj
      value = v
      idx = i
      value2 = v2
    end
  end
  return max, value, value2, idx
end
function objlist:FindFirstPredicate(predicate)
  for i = 1, #self do
    local obj = self[i]
    if predicate(obj) then
      return obj
    end
  end
end
function objlist:FindClosest(pt, dist_func, excluded_obj)
  dist_func = dist_func or "GetDist2D"
  local min_obj, min_dist, idx
  local invalid_pos = InvalidPos()
  for i = 1, #self do
    local obj = self[i]
    if IsValid(obj) and obj:IsValidPos() and obj ~= excluded_obj then
      local dist = obj[dist_func](obj, pt)
      if not min_dist or min_dist > dist then
        min_obj = obj
        min_dist = dist
        idx = i
      end
    end
  end
  return min_obj, min_dist, idx
end
function objlist:MaxObject(member, ...)
  local m_obj, m_idx, m_val
  local func = type(member) == "function"
  for i = 1, #self do
    local obj = self[i]
    local val = not IsValid(obj) or func and member(obj, ...) or obj[member]
    if val and (not m_val or m_val < val) then
      m_val, m_idx, m_obj = val, i, obj
    end
  end
  return m_obj, m_val, m_idx
end
function objlist:MinObject(member, ...)
  local m_obj, m_idx, m_val
  local func = type(member) == "function"
  for i = 1, #self do
    local obj = self[i]
    local val = not IsValid(obj) or func and member(obj, ...) or obj[member]
    if val and (not m_val or m_val > val) then
      m_val, m_idx, m_obj = val, i, obj
    end
  end
  return m_obj, m_val, m_idx
end
function objlist:AveragePos()
  local count, center, error
  local invalid_pos = InvalidPos()
  for i = 1, #self do
    local pos = self[i]:GetPos()
    if pos ~= invalid_pos then
      if count then
        count = count + 1
        local v = pos - center + error
        center = center + v / count
        error = v % count
      else
        count = 1
        center = pos
        error = point30
      end
    end
  end
  if count then
    return center + 2 * error / count
  else
    return invalid_pos
  end
end
function objlist:AverageVisualPos()
  local count, center, error
  local invalid_pos = InvalidPos()
  for i = 1, #self do
    local pos = self[i]:GetVisualPos()
    if pos ~= invalid_pos then
      if count then
        count = count + 1
        local v = pos - center + error
        center = center + v / count
        error = v % count
      else
        count = 1
        center = pos
        error = point30
      end
    end
  end
  if count then
    return center + 2 * error / count
  else
    return invalid_pos
  end
end
function objlist:Fold(f, acc)
  for i = 1, #self do
    acc = f(self[i], acc)
  end
  return acc
end
function objlist:SortBy(...)
  table.sortby(self, ...)
end
function objlist:ForEach(f, ...)
  local count = #self
  if type(f) == "string" then
    for i = 1, count do
      local obj = self[i]
      local result = obj[f](obj, ...)
      if type(result) ~= "nil" then
        return result
      end
    end
  elseif type(f) == "function" then
    for i = 1, count do
      local result = f(self[i], ...)
      if type(result) ~= "nil" then
        return result
      end
    end
  end
end
function objlist:IsTrueForAll(f, ...)
  if type(f) == "string" then
    for i = 1, #self do
      local o = self[i]
      if not o:HasMember(f) or not o[f](o, ...) then
        return false
      end
    end
  else
    for i = 1, #self do
      local o = self[i]
      if not f(o, ...) then
        return false
      end
    end
  end
  return true
end
function objlist:IsTrueForAny(f, ...)
  if type(f) == "string" then
    for i = 1, #self do
      local o = self[i]
      if o:HasMember(f) and o[f](o, ...) then
        return true
      end
    end
  else
    for i = 1, #self do
      local o = self[i]
      if f(o, ...) then
        return true
      end
    end
  end
  return false
end
function objlist:Validate()
  local remove = table.remove
  local IsValid = IsValid
  for i = #self, 1, -1 do
    if not IsValid(self[i]) then
      remove(self, i)
    end
  end
  return self
end
function objlist:tostring()
  local str = "objlist {"
  for index = 1, #self do
    local obj = self[index]
    str = str .. " " .. tostring(index) .. " = " .. (type(obj) == "table" and tostring(obj.class) .. "{h=" .. tostring(rawget(obj, "__chandle")) .. "}" or tostring(obj))
  end
  str = str .. " }"
  return str
end
function objlist:print()
  print(self:tostring())
end
function objlist:Copy()
  local list = objlist:new({})
  for i = 1, #self do
    list[i] = self[i]
  end
  return list
end
function objlist.equals(ol1, ol2)
  if #ol1 ~= #ol2 then
    return false
  end
  for i = 1, #ol1 do
    if ol1[i] ~= ol2[i] then
      return false
    end
  end
  return true
end
function objlist.ContainSameItems(ol1, ol2)
  if #ol1 ~= #ol2 then
    return false
  end
  local items = {}
  for i = 1, #ol1 do
    items[ol1[i]] = (items[ol1[i]] or 0) + 1
    items[ol2[i]] = (items[ol2[i]] or 0) - 1
  end
  for key, val in pairs(items) do
    if val ~= 0 then
      return false
    end
  end
  return true
end
function objlist:GetRandomObj(weight, random_func, ...)
  random_func = random_func or AsyncRandRange
  if not weight then
    return self[random_func(1, #self, ...)]
  else
    local sum = 0
    for i = 1, #self do
      local o = self[i]
      sum = sum + (weight[o] or 100)
    end
    local rand = random_func(1, sum, ...)
    sum = 0
    for i = 1, #self do
      local o = self[i]
      if weight[o] ~= 0 then
        sum = sum + (weight[o] or 100)
        if rand <= sum then
          return self[i]
        end
      end
    end
  end
end
function objlist:GetRandomObjs(weight, random_func, number)
  if not weight then
    local r = {}
    for i = 1, number do
      r[i] = random_func(1, #self - i + 1)
    end
    for i = 1, number do
      local a = r[i]
      for j = i + 1, number do
        if a <= r[j] then
          r[j] = r[j] + 1
        end
      end
    end
    local result = {}
    for i = 1, #r do
      local o = self[r[i]]
      if not o then
        break
      end
      table.insert(result, o)
    end
    return objlist:new(result)
  else
    local sum = 0
    for i = 1, #self do
      local o = self[i]
      sum = sum + (weight[o] or 100)
    end
    local picked = {}
    local result = {}
    for j = 1, number do
      local rand = random_func(1, sum)
      local rsum = 0
      for i = 1, #self do
        local o = self[i]
        if weight[o] ~= 0 and not picked[o] then
          rsum = rsum + (weight[o] or 100)
          if rand <= rsum then
            table.insert(result, o)
            picked[o] = true
            sum = sum - (weight[o] or 100)
            break
          end
        end
      end
    end
  end
end
function objlist:RandomObjAsync(weight)
  return self:GetRandomObj(weight, AsyncRandRange)
end
function objlist:Destroy()
  for i = #self, 1, -1 do
    local o = self[i]
    self[i] = nil
    if IsValid(o) then
      DoneObject(o)
    end
  end
end
function objlist:SetCommand(cmd, ...)
  for i = 1, #self do
    self[i]:SetCommand(cmd, ...)
  end
end
function objlist:CountClass(class)
  local count = 0
  for i = 1, self:Count() do
    if self[i]:IsKindOf(class) then
      count = count + 1
    end
  end
  return count
end
function objlist:FilterClass(class)
  return self:MapFilter("map", class)
end
function objlist:FilterObjects(table)
  return FilterObjects(table, self)
end
function objlist:MapFilter(...)
  return MapFilter(self, ...)
end
objlist.__index = objlist
objlist.userdatatype__ = "objlist"
objlist_weak = {__mode = "v"}
objlist_weak.__index = objlist_weak
setmetatable(objlist_weak, objlist)
function OnMsg.PersistGatherPermanents(permanents)
  permanents.objlist = objlist
  permanents.objlist_weak = objlist_weak
end
