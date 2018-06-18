-- See LICENSE for terms

local Concat = FlattenGround.ComFuncs.Concat --added in Init.lua

local pcall,tonumber,tostring,next,pairs,print,type,select,getmetatable,setmetatable = pcall,tonumber,tostring,next,pairs,print,type,select,getmetatable,setmetatable
local table,debug,string = table,debug,string

local _InternalTranslate = _InternalTranslate
local AsyncFileToString = AsyncFileToString
local AsyncFileRename = AsyncFileRename
local AsyncListFiles = AsyncListFiles
local AsyncRand = AsyncRand
local AsyncStringToFile = AsyncStringToFile
local box = box
local CreateGameTimeThread = CreateGameTimeThread
local CreateRealTimeThread = CreateRealTimeThread
local CreateRolloverWindow = CreateRolloverWindow
local DoneObject = DoneObject
local FilterObjects = FilterObjects
local GetInGameInterface = GetInGameInterface
local GetLogFile = GetLogFile
local GetObjects = GetObjects
local GetPreciseTicks = GetPreciseTicks
local GetTerrainCursor = GetTerrainCursor
local GetXDialog = GetXDialog
local HandleToObject = HandleToObject
local IsBox = IsBox
local IsObjlist = IsObjlist
local IsPoint = IsPoint
local IsValid = IsValid
local Msg = Msg
local OpenXDialog = OpenXDialog
local point = point
local RGB = RGB
local Sleep = Sleep
local TechDef = TechDef
local ThreadLockKey = ThreadLockKey
local ThreadUnlockKey = ThreadUnlockKey
local ViewPos = ViewPos
local WaitMarsQuestion = WaitMarsQuestion
local WaitPopupNotification = WaitPopupNotification

local local_T = T -- T replaced below
local guic = guic

local UserActions_SetMode = UserActions.SetMode
local terminal_GetMousePos = terminal.GetMousePos
local UIL_MeasureText = UIL.MeasureText
local terrain_IsPointInBounds = terrain.IsPointInBounds
local FontStyles_GetFontId = FontStyles.GetFontId

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

-- change some annoying stuff about UserActions.AddActions()
local g_idxAction = 0
function FlattenGround.ComFuncs.UserAddActions(ActionsToAdd)
if FlattenGround.Temp.Testing then
  if type(ActionsToAdd) == "string" then
    print("ActionsToAdd",ActionsToAdd)
  end
end
  for k, v in pairs(ActionsToAdd) do
    if type(v.action) == "function" and (v.key ~= nil and v.key ~= "" or v.xinput ~= nil and v.xinput ~= "" or v.menu ~= nil and v.menu ~= "" or v.toolbar ~= nil and v.toolbar ~= "") then
      if v.key ~= nil and v.key ~= "" then
        if type(v.key) == "table" then
          local keys = v.key
          if #keys <= 0 then
            v.description = ""
          else
            v.description = Concat(v.description," (",keys[1])
            for i = 2, #keys do
              v.description = Concat(v.description," ",T(302535920000165--[[or--]])," ",keys[i])
            end
            v.description = Concat(v.description,")")
          end
        else
          v.description = Concat(tostring(v.description)," (",v.key,")")
        end
      end
      v.id = k
      v.idx = g_idxAction
      g_idxAction = g_idxAction + 1
      UserActions.Actions[k] = v
    else
      UserActions.RejectedActions[k] = v
    end
  end
  UserActions_SetMode(UserActions.mode)
end

function FlattenGround.ComFuncs.AddAction(Menu,Action,Key,Des,Icon,Toolbar,Mode,xInput,ToolbarDefault)
  local FlattenGround = FlattenGround
  if Menu then
    Menu = Concat("/",tostring(Menu))
  end
  local name = "NOFUNC"
  --add name to action id
  if Action then
    local debug_info = debug.getinfo(Action, "Sn")
    local text = tostring(Concat(debug_info.short_src,"(",debug_info.linedefined,")"))
    name = text:gsub(FlattenGround.ModPath,"")
    name = name:gsub(FlattenGround.ModPath:gsub("AppData","...ata"),"")
    name = name:gsub(FlattenGround.ModPath:gsub("AppData","...a"),"")
    --
  elseif FlattenGround.Temp.Testing and Key ~= "Skip" then
    FlattenGround.Temp.StartupMsgs[#FlattenGround.Temp.StartupMsgs+1] = Concat("<color 255 100 100>",T(302535920000000--[[Expanded Cheat Menu--]]),"</color><color 0 0 0>: </color><color 128 255 128>",T(302535920000166--[[BROKEN FUNCTION--]]),": </color>",Menu)
  end

  --T(Number from Game.csv)
  --UserActions.AddActions({
  --UserActions.RejectedActions()
  FlattenGround.ComFuncs.UserAddActions({
    [Concat("FlattenGround_",name,"-",AsyncRand())] = {
      menu = Menu,
      action = Action,
      key = Key,
      description = Des or "", --errors if not a string
      icon = Icon,
      toolbar = Toolbar,
      mode = Mode,
      xinput = xInput,
      toolbar_default = ToolbarDefault
    }
  })
end
