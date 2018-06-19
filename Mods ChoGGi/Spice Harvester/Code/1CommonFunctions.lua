local Concat = SpiceHarvester.ComFuncs.Concat

local type,pcall,table,tostring = type,pcall,table,tostring

local CreateRealTimeThread = CreateRealTimeThread
local GetInGameInterface = GetInGameInterface
local _InternalTranslate = _InternalTranslate
local AsyncRand = AsyncRand
local OpenXDialog = OpenXDialog
local GetXDialog = GetXDialog

local local_T = T

local g_Classes = g_Classes

-- I want a translate func to always return a string
function SpiceHarvester.ComFuncs.Trans(...)
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
local T = SpiceHarvester.ComFuncs.Trans

-- backup orginal function for later use (checks if we already have a backup, or else problems)
function SpiceHarvester.ComFuncs.SaveOrigFunc(ClassOrFunc,Func)
  local SpiceHarvester = SpiceHarvester
  if Func then
    local newname = Concat(ClassOrFunc,"_",Func)
    if not SpiceHarvester.OrigFuncs[newname] then
      SpiceHarvester.OrigFuncs[newname] = g_Classes[ClassOrFunc][Func]
    end
  else
    if not SpiceHarvester.OrigFuncs[ClassOrFunc] then
      SpiceHarvester.OrigFuncs[ClassOrFunc] = _G[ClassOrFunc]
    end
  end
end

function SpiceHarvester.ComFuncs.MsgPopup(Msg,Title,Icon,Size)
  Icon = type(tostring(Icon):find(".tga")) == "number" and Icon
  --eh, it needs something for the id, so I can fiddle with it later
  local id = AsyncRand()
  --build our popup
  local timeout = 10000
  if Size then
    timeout = 30000
  end
  local params = {
    expiration=timeout, --{expiration=99999999999999999}
    --dismissable=false,
  }
  local cycle_objs = params.cycle_objs
  local dlg = GetXDialog("OnScreenNotificationsDlg")
  if not dlg then
    if not GetInGameInterface() then
      return
    end
    dlg = OpenXDialog("OnScreenNotificationsDlg", GetInGameInterface())
  end
  local data = {
    id = id,
    --name = id,
    title = tostring(Title or ""),
    text = tostring(Msg or T(3718--[[NONE--]])),
    image = Icon
  }
  table.set_defaults(data, params)
  table.set_defaults(data, g_Classes.OnScreenNotificationPreset)

  CreateRealTimeThread(function()
		local popup = g_Classes.OnScreenNotification:new({}, dlg.idNotifications)
		popup:FillData(data, nil, params, cycle_objs)
		popup:Open()
		dlg:ResolveRelativeFocusOrder()
  end)
end
