local Concat = ForceNewDome.ComFuncs.Concat
local TConcat = ForceNewDome.ComFuncs.TableConcat

local table,pcall,type,getmetatable,tostring = table,pcall,type,getmetatable,tostring

local IsObjlist = IsObjlist
local _InternalTranslate = _InternalTranslate
local RGBA = RGBA
local ViewPos = ViewPos
local local_T = T

local g_Classes = g_Classes

-- I want a translate func to always return a string
function ForceNewDome.ComFuncs.Trans(...)
  local trans
  local vararg = {...}
  -- just in case a
  pcall(function()
    if type(vararg[1]) == "userdata" then
      trans = _InternalTranslate(table.unpack(vararg))
    else
      trans = _InternalTranslate(local_T(vararg))
    end
  end)
  -- just in case b
  if type(trans) ~= "string" then
    if type(vararg[2]) == "string" then
      return vararg[2]
    end
    -- done fucked up (just in case c)
    return Concat(vararg[1]," < Missing locale string id")
  end
  return trans
end
local T = ForceNewDome.ComFuncs.Trans

-- returns object name or at least always some string
function ForceNewDome.ComFuncs.RetName(obj)
  if obj == _G then
    return "_G"
  end
  local name
  if type(obj) == "table" then
    if obj.name and obj.name ~= "" then
      --colonist names
      if type(obj.name) == "table" then
        name = {}
        for i = 1, #obj.name do
          name[i] = T(obj.name[i])
        end
        return TConcat(name)
      --custom name from user (probably)
      else
        return obj.name
      end
    --translated name
    elseif obj.display_name and obj.display_name ~= "" then
      return T(obj.display_name)
    --added this here as doing tostring lags the shit outta kansas if this is a large objlist
    elseif IsObjlist(obj) then
      return "objlist"
    end
    --class or encyclopedia_id
    name = getmetatable(obj)
    if name and type(name.class) == "string" then
      return name.class
    end
    name = obj.encyclopedia_id or obj.class
  end

  --if .class or .encyclopedia_id worked
  if type(name) == "string" then
    return name
  end

  --falling back baby
--~   return tostring(obj):sub(1,150) --limit length of string in case it's a large one
  return tostring(obj)
end

function ForceNewDome.ComFuncs.PopupToggle(parent,popup_id,items)
  local g_Classes = g_Classes

  local popup = g_Classes.XPopupList:new({
    Opened = true,
    Id = popup_id,
    ZOrder = 2000001, --1 above consolelog
    Dock = "top",
    Margins = box(0, 0, 0, 5),
    LayoutMethod = "VList",
  }, terminal.desktop)

  for i = 1, #items do
    local item = items[i]
    local button = g_Classes[item.class]:new({
      TextFont = "Editor16Bold",
      RolloverText = item.hint,
      RolloverTemplate = "Rollover",
      Text = item.name,
      RolloverBackground = RGBA(40, 163, 255, 128),
      OnMouseEnter = function()
        if item.pos then
          ViewPos(item.pos)
        end
      end,
      OnMouseButtonDown = item.clicked or function()end,
      OnMouseButtonUp = function()
        popup:Close()
      end,
    }, popup.idContainer)
--~     button:SetRollover(item.hint)

    --i just love checkmarks
    if item.value then
      local value = _G[item.value]
      local is_vis
      if type(value) == "table" then
        if value.visible then
          is_vis = true
        end
      else
        if value then
          is_vis = true
        end
      end

      if is_vis then
        button:SetCheck(true)
      else
        button:SetCheck(false)
      end
    end
  end

  popup:SetAnchor(parent.box)
  popup:SetAnchorType("left")
  popup:Open()
  popup:SetFocus()
  return popup
end
