-- See LICENSE for terms

local select,type,getmetatable,tostring,table = select,type,getmetatable,tostring,table

local IsObjlist = IsObjlist
local GetObjects = GetObjects
local CreateRealTimeThread = CreateRealTimeThread
local OpenXDialog = OpenXDialog
local GetInGameInterface = GetInGameInterface
local GetXDialog = GetXDialog
local TConcat = oldTableConcat or table.concat

local g_Classes = g_Classes



local concat_table = {}
local concat_value
local function Concat(...)
  -- reuse old table if it's not that big, else it's quicker to make new one (should probably bench till i find a good medium rather than just using 500)
  if #concat_table > 500 then
    concat_table = {}
  else
    table.iclear(concat_table) -- i assume sm added a c func to clear tables, which does seem to be faster than a "lua for loop"
  end
  -- build table from args (see if devs added a c func to do this?)
  for i = 1, select("#",...) do
    concat_value = select(i,...)
    if type(concat_value) == "string" or type(concat_value) == "number" then
      concat_table[i] = concat_value
    else
      concat_table[i] = tostring(concat_value)
    end
  end
  -- and done
  return TableConcat(concat_table)
end

-- returns object name or at least always some string
local function RetName(obj)
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

-- shows a popup msg with the rest of the notifications
local function MsgPopup(Msg,Title,Icon,Size)
  --build our popup
  local timeout = 10000
  local params = {
    expiration=timeout, --{expiration=99999999999999999}
    --dismissable=false,
  }
  ---if there's no interface then we probably shouldn't open the popup
  local dlg = GetXDialog("OnScreenNotificationsDlg")
  if not dlg then
    if not GetInGameInterface() then
      return
    end
    dlg = OpenXDialog("OnScreenNotificationsDlg", GetInGameInterface())
  end
  --build the popup
  local data = {
    id = AsyncRand(),
    title = tostring(Title or ""),
    text = tostring(Msg or T(3718--[[NONE--]])),
    image = type(tostring(Icon):find(".tga")) == "number" and Icon
  }
  table.set_defaults(data, params)
  table.set_defaults(data, g_Classes.OnScreenNotificationPreset)
  --and show the popup
  CreateRealTimeThread(function()
		local popup = g_Classes.OnScreenNotification:new({}, dlg.idNotifications)
		popup:FillData(data, nil, params, params.cycle_objs)
		popup:Open()
		dlg:ResolveRelativeFocusOrder()
  end)
end

function OnMsg.NewHour()
  local objs = GetObjects{class = "Unit"} or empty_table
  for i = 1, #objs do
    -- 102 is from :GetMoveAnim(), 0 is stopped or idle?
    if objs[i]:GetAnim() > 0 and objs[i]:GetPathLen() == 0 then
      --trying to move with no path = lag
      objs[i]:InterruptCommand()
      MsgPopup(
        Concat(RetName(objs[i])," at position: ",objs[i]:GetVisualPos()," was stopped."),
        "Broked Pathing",
        "UI/Icons/IPButtons/transport_route.tga"
      )
    end
  end
end