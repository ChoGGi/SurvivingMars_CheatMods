-- See LICENSE for terms

local Concat = FlattenGround.ComFuncs.Concat --added in Init.lua

local pcall,tostring,pairs,print,type = pcall,tostring,pairs,print,type
local table,debug = table,debug

local _InternalTranslate = _InternalTranslate
local AsyncRand = AsyncRand
local CreateRealTimeThread = CreateRealTimeThread
local GetInGameInterface = GetInGameInterface
local GetXDialog = GetXDialog
local OpenXDialog = OpenXDialog

local local_T = T -- T replaced below

local UserActions_SetMode = UserActions.SetMode

local g_Classes = g_Classes

-- I want a translate func to always return a string
function FlattenGround.ComFuncs.Trans(...)
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
local T = FlattenGround.ComFuncs.Trans

-- shows a popup msg with the rest of the notifications
function FlattenGround.ComFuncs.MsgPopup(Msg,Title,Icon)
  local FlattenGround = FlattenGround
  Icon = type(tostring(Icon):find(".tga")) == "number" and Icon or Concat(FlattenGround.MountPath,"TheIncal.tga")
  --eh, it needs something for the id, so I can fiddle with it later
  local id = AsyncRand()
  --build our popup
  local timeout = 10000
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

