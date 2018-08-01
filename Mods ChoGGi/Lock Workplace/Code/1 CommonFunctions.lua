--See LICENSE for terms

local Concat = LockWorkplace.ComFuncs.Concat --added in Init.lua

local pcall,tonumber,tostring,next,pairs,print,type,select,getmetatable,setmetatable = pcall,tonumber,tostring,next,pairs,print,type,select,getmetatable,setmetatable
local table,debug,string = table,debug,string

local _InternalTranslate = _InternalTranslate

local local_T = T -- T replaced below

-- I want a translate func to always return a string
function LockWorkplace.ComFuncs.Trans(...)
  local trans
  local vararg = {...}
  --just in case a
  pcall(function()
    if type(vararg[1]) == "userdata" then
      trans = _InternalTranslate(table.unpack(vararg))
    else
      trans = _InternalTranslate(local_T(vararg))
    end
  end)
  --just in case b
  if type(trans) ~= "string" then
    if type(vararg[2]) == "string" then
      return vararg[2]
    end
    --we don't translate this one (just in case c)
    return Concat("Missing locale string id: ",vararg[1])
  end
  return trans
end
local T = LockWorkplace.ComFuncs.Trans

-- returns object name or at least always some string
function LockWorkplace.ComFuncs.RetName(obj)
  if obj == _G then
    return "_G"
  end
  local name
  if type(obj) == "table" then
    --custom name
    if obj.name ~= "" then
      return obj.name
    --translated name
    elseif type(obj.display_name) == "userdata" or type(obj.display_name) == "string" then
      return T(obj.display_name)
    elseif IsObjlist(obj) then
      return "objlist"
    end

    name = getmetatable(obj)
    if name and type(name.class) == "string" then
      return name.class
    end
    name = obj.encyclopedia_id or obj.class
  end

  if type(name) == "string" then
    return name
  end

  --falling back baby (lags the shit outta kansas if this is a large objlist)
  return tostring(obj)
end
