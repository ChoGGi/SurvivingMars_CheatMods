--See LICENSE for terms

local Concat = SolariaTelepresence.ComFuncs.Concat --added in Init.lua

local pcall,tonumber,tostring,next,pairs,print,type,select,getmetatable,setmetatable = pcall,tonumber,tostring,next,pairs,print,type,select,getmetatable,setmetatable
local table,debug,string = table,debug,string

local _InternalTranslate = _InternalTranslate
local AsyncCreatePath = AsyncCreatePath
local AsyncFileDelete = AsyncFileDelete
local AsyncFileOpen = AsyncFileOpen
local AsyncFileRename = AsyncFileRename
local AsyncFileToString = AsyncFileToString
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
local GetObjects = GetObjects
local GetTerrainCursor = GetTerrainCursor
local GetXDialog = GetXDialog
local HandleToObject = HandleToObject
local IsBox = IsBox
local IsObjlist = IsObjlist
local IsPoint = IsPoint
local IsValid = IsValid
local Msg = Msg
local OnScreenNotificationPreset = OnScreenNotificationPreset
local OpenXDialog = OpenXDialog
local point = point
local RGB = RGB
local RGBA = RGBA
local ShowConsoleLog = ShowConsoleLog
local Sleep = Sleep
local TechDef = TechDef
local ThreadLockKey = ThreadLockKey
local ThreadUnlockKey = ThreadUnlockKey
local ViewPos = ViewPos
local WaitMarsQuestion = WaitMarsQuestion
local WaitPopupNotification = WaitPopupNotification

local T = T -- T replaced below
local guic = guic

local UserActions_SetMode = UserActions.SetMode
local terminal_GetMousePos = terminal.GetMousePos
local UIL_MeasureText = UIL.MeasureText
local terrain_IsPointInBounds = terrain.IsPointInBounds


-- I want a translate func to always return a string
function SolariaTelepresence.ComFuncs.Trans(...)
  local trans
  local vararg = {...}
  --just in case a
  pcall(function()
    if type(vararg[1]) == "userdata" then
      trans = _InternalTranslate(table.unpack(vararg))
    else
      trans = _InternalTranslate(T(vararg))
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
local T = SolariaTelepresence.ComFuncs.Trans


-- backup orginal function for later use (checks if we already have a backup, or else problems)
function SolariaTelepresence.ComFuncs.SaveOrigFunc(ClassOrFunc,Func)
  local SolariaTelepresence = SolariaTelepresence
  if Func then
    local newname = Concat(ClassOrFunc,"_",Func)
    if not SolariaTelepresence.OrigFuncs[newname] then
      SolariaTelepresence.OrigFuncs[newname] = _G[ClassOrFunc][Func]
    end
  else
    if not SolariaTelepresence.OrigFuncs[ClassOrFunc] then
      SolariaTelepresence.OrigFuncs[ClassOrFunc] = _G[ClassOrFunc]
    end
  end
end


-- shows a popup msg with the rest of the notifications
function SolariaTelepresence.ComFuncs.MsgPopup(Msg,Title,Icon,Size)
  local SolariaTelepresence = SolariaTelepresence
  local g_Classes = g_Classes
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
    id = AsyncRand(),
    --name = id,
    title = tostring(Title or ""),
    text = tostring(Msg or T(3718--[[NONE--]])),
    image = type(tostring(Icon):find(".tga")) == "number" and Icon or Concat(SolariaTelepresence.MountPath,"TheIncal.tga")
  }
  table.set_defaults(data, params)
  table.set_defaults(data, g_Classes.OnScreenNotificationPreset)

  CreateRealTimeThread(function()
		local popup = g_Classes.OnScreenNotification:new({}, dlg.idNotifications)
		popup:FillData(data, nil, params, cycle_objs)
		popup:Open()
		dlg:ResolveRelativeFocusOrder()
    --large amount of text option
  end)
end

-- well that's the question isn't it?
function SolariaTelepresence.ComFuncs.QuestionBox(Msg,Function,Title,Ok,Cancel)
  pcall(function()
    CreateRealTimeThread(function()
      --fire callback if user clicks ok
      local answer = WaitMarsQuestion(nil,
        tostring(Title or ""),
        tostring(Msg or ""),
        tostring(Ok or T(6878--[[OK--]])),
        tostring(Cancel or T(6879--[[Cancel--]]))
      )
      if answer == "ok" then
        Function(true)
      else
        Function()
      end
    end)
  end)
end

function SolariaTelepresence.ComFuncs.FilterFromTable(Table,ExcludeList,IncludeList,Type)
  return FilterObjects({
    filter = function(Obj)
      if ExcludeList or IncludeList then
        if ExcludeList and IncludeList then
          if not ExcludeList[Obj[Type]] then
            return Obj
          elseif IncludeList[Obj[Type]] then
            return Obj
          end
        elseif ExcludeList then
          if not ExcludeList[Obj[Type]] then
            return Obj
          end
        elseif IncludeList then
          if IncludeList[Obj[Type]] then
            return Obj
          end
        end
      else
        if Obj[Type] then
          return Obj
        end
      end
    end
  },Table)
end

function SolariaTelepresence.ComFuncs.CompareTableValue(a,b,sName)
  if not a and not b then
    return
  end
  if type(a[sName]) == type(b[sName]) then
    return a[sName] < b[sName]
  else
    return tostring(a[sName]) < tostring(b[sName])
  end
end

-- returns object name or at least always some string
function SolariaTelepresence.ComFuncs.RetName(obj)
  if obj == _G then
    return "_G"
  end
  local name
  if type(obj) == "table" then
    --translated name
    if type(obj.display_name) == "userdata" then
      return T(obj.display_name)
    elseif IsObjlist(obj) then
      return "objlist"
      --return the name of the first one?
--~       return SolariaTelepresence.ComFuncs.RetName(obj[1])
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

function SolariaTelepresence.ComFuncs.CompareTableValue(a,b,sName)
  if not a and not b then
    return
  end
  if type(a[sName]) == type(b[sName]) then
    return a[sName] < b[sName]
  else
    return tostring(a[sName]) < tostring(b[sName])
  end
end

function SolariaTelepresence.ComFuncs.PopupToggle(parent,popup_id,items)
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
