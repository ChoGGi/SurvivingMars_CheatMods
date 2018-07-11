-- See LICENSE for terms

local TConcat
local Concat = ChoGGi.ComFuncs.Concat --added in Init.lua

local pcall,tonumber,tostring,next,pairs,print,type,select,getmetatable,setmetatable = pcall,tonumber,tostring,next,pairs,print,type,select,getmetatable,setmetatable
local table,debug,string = table,debug,string

local _InternalTranslate = _InternalTranslate
local AsyncFileToString = AsyncFileToString
local AsyncFileRename = AsyncFileRename
local AsyncListFiles = AsyncListFiles
local AsyncRand = AsyncRand
local AsyncStringToFile = AsyncStringToFile
local box = box
local CreateRealTimeThread = CreateRealTimeThread
local CreateRolloverWindow = CreateRolloverWindow
local DelayedCall = DelayedCall
local DoneObject = DoneObject
local FilterObjects = FilterObjects
local GetInGameInterface = GetInGameInterface
local GetLogFile = GetLogFile
local GetObjects = GetObjects
local GetPreciseTicks = GetPreciseTicks
local GetTerrainCursor = GetTerrainCursor
local GetXDialog = GetXDialog
local HandleToObject = HandleToObject
local HexGridGetObject = HexGridGetObject
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
local WorldToHex = WorldToHex
local HexGridGetObjects = HexGridGetObjects

local local_T = T -- T replaced below
local guic = guic

local UserActions_SetMode = UserActions.SetMode
local terminal_GetMousePos = terminal.GetMousePos
local UIL_MeasureText = UIL.MeasureText
local terrain_IsPointInBounds = terrain.IsPointInBounds
local FontStyles_GetFontId = FontStyles.GetFontId

--~ local g_Classes = g_Classes

-- backup orginal function for later use (checks if we already have a backup, or else problems)
function ChoGGi.ComFuncs.SaveOrigFunc(ClassOrFunc,Func)
  local ChoGGi = ChoGGi
  if Func then
    local newname = Concat(ClassOrFunc,"_",Func)
    if not ChoGGi.OrigFuncs[newname] then
--~       ChoGGi.OrigFuncs[newname] = _G[ClassOrFunc][Func]
      ChoGGi.OrigFuncs[newname] = g_Classes[ClassOrFunc][Func]
    end
  else
    if not ChoGGi.OrigFuncs[ClassOrFunc] then
      ChoGGi.OrigFuncs[ClassOrFunc] = _G[ClassOrFunc]
    end
  end
end

-- changes a function to also post a Msg for use with OnMsg
function ChoGGi.ComFuncs.AddMsgToFunc(ClassName,FuncName,sMsg)
  local ChoGGi = ChoGGi
  --save orig
  ChoGGi.ComFuncs.SaveOrigFunc(ClassName,FuncName)
  --redefine it
  g_Classes[ClassName][FuncName] = function(...)
--~   _G[ClassName][FuncName] = function(...)
    --I just care about adding self to the msgs
    Msg(sMsg,select(1,...))

--~     --use to debug if getting an error
--~     local params = {...}
--~     --pass on args to orig func
--~     if not pcall(function()
--~       return ChoGGi.OrigFuncs[Concat(ClassName,"_",FuncName)](table.unpack(params))
--~     end) then
--~       print("Function Error: ",Concat(ClassName,"_",FuncName))
--~       OpenExamine({params})
--~     end
    return ChoGGi.OrigFuncs[Concat(ClassName,"_",FuncName)](...)
  end
end
-- Custom Msgs
local AddMsgToFunc = ChoGGi.ComFuncs.AddMsgToFunc
AddMsgToFunc("CargoShuttle","GameInit","ChoGGi_SpawnedShuttle")
AddMsgToFunc("Drone","GameInit","ChoGGi_SpawnedDrone")
AddMsgToFunc("RCTransport","GameInit","ChoGGi_SpawnedRCTransport")
AddMsgToFunc("RCRover","GameInit","ChoGGi_SpawnedRCRover")
AddMsgToFunc("ExplorerRover","GameInit","ChoGGi_SpawnedExplorerRover")
AddMsgToFunc("Residence","GameInit","ChoGGi_SpawnedResidence")
AddMsgToFunc("Workplace","GameInit","ChoGGi_SpawnedWorkplace")
AddMsgToFunc("ElectricityProducer","CreateElectricityElement","ChoGGi_SpawnedProducerElectricity")
AddMsgToFunc("AirProducer","CreateLifeSupportElements","ChoGGi_SpawnedProducerAir")
AddMsgToFunc("WaterProducer","CreateLifeSupportElements","ChoGGi_SpawnedProducerWater")
AddMsgToFunc("SingleResourceProducer","Init","ChoGGi_SpawnedProducerSingle")
AddMsgToFunc("PinnableObject","TogglePin","ChoGGi_TogglePinnableObject")
AddMsgToFunc("ResourceStockpileLR","GameInit","ChoGGi_SpawnedResourceStockpileLR")
AddMsgToFunc("DroneHub","GameInit","ChoGGi_SpawnedDroneHub")
AddMsgToFunc("Diner","GameInit","ChoGGi_SpawnedDinerGrocery")
AddMsgToFunc("Grocery","GameInit","ChoGGi_SpawnedDinerGrocery")
AddMsgToFunc("SpireBase","GameInit","ChoGGi_SpawnedSpireBase")
AddMsgToFunc("ElectricityGridElement","ApplyToGrids","ChoGGi_CreatedGridObject")
AddMsgToFunc("ElectricityGridElement","RemoveFromGrids","ChoGGi_RemovedGridObject")
AddMsgToFunc("LifeSupportGridElement","ApplyToGrids","ChoGGi_CreatedGridObject")
AddMsgToFunc("LifeSupportGridElement","RemoveFromGrids","ChoGGi_RemovedGridObject")
AddMsgToFunc("ElectricityStorage","GameInit","ChoGGi_SpawnedElectricityStorage")
AddMsgToFunc("LifeSupportGridObject","GameInit","ChoGGi_SpawnedLifeSupportGridObject")

local memoize = {
  _VERSION     = 'memoize v2.0',
  _DESCRIPTION = 'Memoized functions in Lua',
  _URL         = 'https://github.com/kikito/memoize.lua',
  _LICENSE     = [[
    MIT LICENSE

    Copyright (c) 2018 Enrique García Cota

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]]
}
-- Inspired by http://stackoverflow.com/questions/129877/how-do-i-write-a-generic-memoize-function

-- private stuff

local function is_callable(f)
  local tf = type(f)
  if tf == 'function' then return true end
  if tf == 'table' then
    local mt = getmetatable(f)
    return type(mt) == 'table' and is_callable(mt.__call)
  end
  return false
end

local function cache_get(cache, params)
  local node = cache
  for i=1, #params do
    node = node.children and node.children[params[i]]
    if not node then return nil end
  end
  return node.results
end

local function cache_put(cache, params, results)
  local node = cache
  local param
  for i=1, #params do
    param = params[i]
    node.children = node.children or {}
    node.children[param] = node.children[param] or {}
    node = node.children[param]
  end
  node.results = results
end

-- public function

function memoize.memoize(f, cache)
  cache = cache or {}

  if not is_callable(f) then
    print(string.format(
            "If you get this msg contact me, thanks.\n\nOnly functions and callable tables are memoizable. Received %s (a %s)",
             tostring(f), type(f)))
  end
  return function (...)
    local params = {...}

    local results = cache_get(cache, params)
    if not results then
      results = { f(...) }
      cache_put(cache, params, results)
    end

    return table.unpack(results)
  end
end
setmetatable(memoize, { __call = function(_, ...) return memoize.memoize(...) end })
ChoGGi.ComFuncs.Memoize = memoize.memoize
local Memoize = memoize.memoize

-- cache translation strings
_InternalTranslate = Memoize(_InternalTranslate)
IsT = Memoize(IsT)
T = Memoize(T)
TDevModeGetEnglishText = Memoize(TDevModeGetEnglishText)

ChoGGi.ComFuncs.TableConcat = Memoize(ChoGGi.ComFuncs.TableConcat)
TConcat = ChoGGi.ComFuncs.TableConcat

-- I want a translate func to always return a string
function ChoGGi.ComFuncs.Trans(...)
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
ChoGGi.ComFuncs.Trans = Memoize(ChoGGi.ComFuncs.Trans)
local T = ChoGGi.ComFuncs.Trans

-- shows a popup msg with the rest of the notifications
function ChoGGi.ComFuncs.MsgPopup(Msg,Title,Icon,Size)
  local ChoGGi = ChoGGi
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
    image = type(tostring(Icon):find(".tga")) == "number" and Icon or Concat(ChoGGi.MountPath,"TheIncal.tga")
  }
  table.set_defaults(data, params)
  table.set_defaults(data, g_Classes.OnScreenNotificationPreset)
  --and show the popup
  CreateRealTimeThread(function()
		local popup = g_Classes.OnScreenNotification:new({}, dlg.idNotifications)
		popup:FillData(data, nil, params, params.cycle_objs)
		popup:Open()
		dlg:ResolveRelativeFocusOrder()
    --large amount of text option (four long lines o' text, or is it five?)
    if Size then
      --larger text limit
      popup.idText.Margins = box(0,0,0,-500)
      --resize title, or move it?
      popup.idTitle.Margins = box(0,-20,0,0)
      --check if this is doing something
      Sleep(0)
      --size/pos of background image
      popup[1].scale = point(2800,2600)
      popup[1].Margins = box(-5,-30,0,-5)
      --update dialog size
      popup:InvalidateMeasure()
      --i don't care for sounds
--~       if type(params.fx_action) == "string" and params.fx_action ~= "" then
--~         PlayFX(params.fx_action)
--~       end
    end
  end)
end
local MsgPopup = ChoGGi.ComFuncs.MsgPopup

do --g_Classes
  local g_Classes = g_Classes
  function ChoGGi.ComFuncs.DialogAddCaption(parent,Table)
    parent.idCaption = g_Classes.StaticText:new(parent)
    parent.idCaption:SetPos(Table.pos)
    parent.idCaption:SetSize(Table.size)
    parent.idCaption:SetHSizing("AnchorToLeft")
    parent.idCaption:SetBackgroundColor(0)
    parent.idCaption:SetFontStyle("Editor14Bold")
    parent.idCaption:SetTextPrefix(Table.prefix or "<center>")
    parent.idCaption:SetText(Table.title or "")
    parent.idCaption.HandleMouse = false
  end

  function ChoGGi.ComFuncs.DialogAddCloseX(parent,func)
    parent.idCloseX = g_Classes.Button:new(parent)
    parent.idCloseX:SetHSizing("AnchorToRight")
    parent.idCloseX:SetPos(parent:GetPos() + point(parent:GetSize():x() - 21, 3))
    parent.idCloseX:SetSize(point(18, 18))
    parent.idCloseX:SetImage("CommonAssets/UI/Controls/Button/Close.tga")
    parent.idCloseX:SetHint(T(1011--[[Close--]]))
    parent.idCloseX.OnButtonPressed = func or function()
      parent:delete()
    end
  end

  function ChoGGi.ComFuncs.DialogXAddButton(parent,text,hint,onpress)
    g_Classes.XTextButton:new({
      RolloverTemplate = "Rollover",
      RolloverText = hint or "",
      RolloverTitle = T(126095410863--[[Info--]]),
      MinWidth = 60,
      Text = text or T(1000616--[[OK--]]),
      OnPress = onpress,
      --center text
      LayoutMethod = "VList",
    }, parent)
  end

  function ChoGGi.ComFuncs.PopupToggle(parent,popup_id,items)
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
--~         RolloverBackground = RGBA(40, 163, 255, 255),
        OnMouseButtonDown = item.clicked or function()end,
        OnMouseButtonUp = function()
          popup:Close()
        end,
        OnMouseEnter = function()
          if item.pos then
            ViewPos(item.pos)
          end
        end,
      }, popup.idContainer)
      button:SetRollover(item.hint)

      --i just love checkmarks
      if item.value then
        local is_vis
        local value
        if type(item.value) == "table" then
          value = ChoGGi.UserSettings[item.value[1]]
        else
          value = _G[item.value]
        end
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
    popup:SetAnchorType("top")
  --~   "smart",
  --~   "left",
  --~   "right",
  --~   "top",
  --~   "center-top",
  --~   "bottom",
  --~   "mouse"

    popup:Open()
    popup:SetFocus()
    return popup
  end

  function ChoGGi.ComFuncs.ShowMe(o, color, time)
    if not o then
      return ChoGGi.ComFuncs.ClearShowMe()
    end
    if type(o) == "table" and #o == 2 then
      if IsPoint(o[1]) and terrain_IsPointInBounds(o[1]) and IsPoint(o[2]) and terrain_IsPointInBounds(o[2]) then
        local m = g_Classes.Vector:new()
        m:Set(o[1], o[2], color)
        markers[m] = "vector"
        o = m
      end
    elseif IsPoint(o) then
      if terrain_IsPointInBounds(o) then
        local m = g_Classes.Sphere:new()
        m:SetPos(o)
        m:SetRadius(50 * guic)
        m:SetColor(color or RGB(0, 255, 0))
        markers[m] = "point"
        if not time then
          ViewPos(o)
        end
        o = m
      end
    elseif IsValid(o) then
      markers[o] = markers[o] or o:GetColorModifier()
      o:SetColorModifier(color or RGB(0, 255, 0))
      local pos = o:GetVisualPos()
      if not time and terrain_IsPointInBounds(pos) then
        ViewPos(pos)
      end
    end
  --~   lm = o
  end

  function ChoGGi.ComFuncs.ShowCircle(pt, r, color)
    local c = g_Classes.Circle:new()
    c:SetPos(pt:SetTerrainZ(10 * guic))
    c:SetRadius(r)
    c:SetColor(color or RGB(255, 255, 255))
    DelayedCall(7000, function()
      if IsValid(c) then
        DoneObject(c)
      end
    end)
--~     CreateGameTimeThread(function()
--~       Sleep(7000)
--~       if IsValid(c) then
--~         DoneObject(c)
--~       end
--~     end)
  end

end

-- centred msgbox with Ok
function ChoGGi.ComFuncs.MsgWait(Msg,Title)
  Title = Title or ""
  CreateRealTimeThread(
    WaitPopupNotification,
    false,
    {title = tostring(Title), text = tostring(Msg)}
  )
end

-- well that's the question isn't it?
function ChoGGi.ComFuncs.QuestionBox(Msg,Function,Title,Ok,Cancel)
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
end

function ChoGGi.ComFuncs.Dump(Obj,Mode,File,Ext,Skip)
  if Mode == "w" or Mode == "w+" then
    Mode = nil
  else
    Mode = "-1"
  end
  Ext = Ext or "txt"
  File = File or "DumpedText"
  local Filename = Concat("AppData/logs/",File,".",Ext)

  if pcall(function()
    ThreadLockKey(Filename)
    AsyncStringToFile(Filename,Obj,Mode)
    ThreadUnlockKey(Filename)
  end) then
    if not Skip then
      MsgPopup(Concat(T(302535920000002--[[Dumped--]]),": ",tostring(Obj)),
        Filename,"UI/Icons/Upgrades/magnetic_filtering_04.tga"
      )
    end
  end
end

function ChoGGi.ComFuncs.DumpLua(Value)
  local which = "TupleToLuaCode"
  if type(Value) == "table" then
    which = "TableToLuaCode"
  elseif type(Value) == "string" then
    which = "StringToLuaCode"
  elseif type(Value) == "userdata" then
    which = "ValueToLuaCode"
  end
  ChoGGi.ComFuncs.Dump(Concat("\r\n",_G[which](Value)),nil,"DumpedLua","lua")
end

--[[
Mode = -1 to append or nil to overwrite (default: -1)
Funcs = true to dump functions as well (default: false)
ChoGGi.ComFuncs.DumpTable(Object)
--]]
function ChoGGi.ComFuncs.DumpTable(Obj,Mode,Funcs)
  local ChoGGi = ChoGGi
  if not Obj then
    MsgPopup(T(302535920000003--[[Can't dump nothing--]]),T(302535920000004--[[Dump--]]))
    return
  end
  Mode = Mode or "-1"
  --make sure it's empty
  ChoGGi.TextFile = ""
  ChoGGi.ComFuncs.DumpTableFunc(Obj,nil,Funcs)
  AsyncStringToFile("AppData/logs/DumpedTable.txt",ChoGGi.TextFile,Mode)

  MsgPopup(Concat(T(302535920000002--[[Dumped--]]),": ",ChoGGi.ComFuncs.RetName(Obj)),
    "AppData/logs/DumpedText.txt"
  )
end

function ChoGGi.ComFuncs.DumpTableFunc(Obj,hierarchyLevel,Funcs)
  local ChoGGi = ChoGGi
  if (hierarchyLevel == nil) then
    hierarchyLevel = 0
  elseif (hierarchyLevel == 4) then
    return 0
  end

  if Obj.id then
    ChoGGi.TextFile = Concat(ChoGGi.TextFile,"\n-----------------Obj.id: ",Obj.id," :")
  end
  if (type(Obj) == "table") then
    for k,v in pairs(Obj) do
      if (type(v) == "table") then
        ChoGGi.ComFuncs.DumpTableFunc(v, hierarchyLevel+1)
      else
        if k ~= nil then
          ChoGGi.TextFile = Concat(ChoGGi.TextFile,"\n",tostring(k)," = ")
        end
        if v ~= nil then
          ChoGGi.TextFile = Concat(ChoGGi.TextFile,tostring(ChoGGi.ComFuncs.RetTextForDump(v,Funcs)))
        end
        ChoGGi.TextFile = Concat(ChoGGi.TextFile,"\n")
      end
    end
  end
end

--[[
ChoGGi.ComFuncs.DumpObject(Consts)
ChoGGi.ComFuncs.DumpObject(const)
if you want to dump functions as well DumpObject(object,true)
--]]
function ChoGGi.ComFuncs.DumpObject(Obj,Mode,Funcs)
  local ChoGGi = ChoGGi
  if not Obj then
    MsgPopup(T(302535920000003--[[Can't dump nothing--]]),T(302535920000004--[[Dump--]]))
    return
  end

  local Text = ""
  for k,v in pairs(Obj) do
    if k ~= nil then
      Text = Concat(Text,"\n",tostring(k)," = ")
    end
    if v ~= nil then
      Text = Concat(Text,tostring(ChoGGi.ComFuncs.RetTextForDump(v,Funcs)))
    end
  end
  ChoGGi.ComFuncs.Dump(Text,Mode)
end

function ChoGGi.ComFuncs.RetTextForDump(Obj,Funcs)
  if type(Obj) == "userdata" then
    return T(Obj)
  elseif Funcs and type(Obj) == "function" then
    return Concat("Func: \n\n",string.dump(Obj),"\n\n")
  elseif type(Obj) == "table" then
    return Concat(tostring(Obj)," len: ",#Obj)
  else
    return tostring(Obj)
  end
end

function ChoGGi.ComFuncs.PrintFiles(Filename,Function,Text,...)
  Text = Text or ""
  --pass ... onto pcall function
  local vararg = ...
  pcall(function()
    ChoGGi.ComFuncs.Dump(Concat(Text,vararg,"\r\n"),nil,Filename,"log",true)
  end)
  if type(Function) == "function" then
    Function(...)
  end
end

-- positive or 1 return TrueVar || negative or 0 return FalseVar
-- ChoGGi.Consts.XXX = ChoGGi.ComFuncs.NumRetBool(ChoGGi.Consts.XXX,0,ChoGGi.Consts.XXX)
function ChoGGi.ComFuncs.NumRetBool(Num,TrueVar,FalseVar)
  if type(Num) ~= "number" then
    return
  end
  local Bool = true
  if Num < 1 then
    Bool = nil
  end
  return Bool and TrueVar or FalseVar
end

-- return opposite value or first value if neither
function ChoGGi.ComFuncs.ValueRetOpp(Setting,Value1,Value2)
  if Setting == Value1 then
    return Value2
  elseif Setting == Value2 then
    return Value1
  end
  --just in case
  return Value1
end

-- return as num
function ChoGGi.ComFuncs.BoolRetNum(Bool)
  if Bool == true then
    return 1
  end
  return 0
end

-- toggle 0/1
function ChoGGi.ComFuncs.ToggleBoolNum(Num)
  if Num == 0 then
    return 1
  end
  return 0
end

-- return equal or higher amount
function ChoGGi.ComFuncs.CompareAmounts(iAmtA,iAmtB)
  --if ones missing then just return the other
  if not iAmtA then
    return iAmtB
  elseif not iAmtB then
    return iAmtA
  --else return equal or higher amount
  elseif iAmtA >= iAmtB then
    return iAmtA
  elseif iAmtB >= iAmtA then
    return iAmtB
  end
end

-- compares two values, if types are different then makes them both strings
--[[
    if sort[a] and sort[b] then
      return sort[a] < sort[b]
    end
    if sort[a] or sort[b] then
      return sort[a] and true
    end
    return CmpLower(a, b)
--]]

--[[
  table.sort(Items,
    function(a,b)
      return ChoGGi.ComFuncs.CompareTableValue(a,b,"text")
    end
  )
--]]
function ChoGGi.ComFuncs.CompareTableValue(a,b,sName)
  if not a and not b then
    return
  end
  if type(a[sName]) == type(b[sName]) then
    return a[sName] < b[sName]
  else
    return tostring(a[sName]) < tostring(b[sName])
  end
end

--[[
table.sort(s.command_centers,
  function(a,b)
    return ChoGGi.ComFuncs.CompareTableFuncs(a,b,"GetDist2D",s)
  end
)
--]]
function ChoGGi.ComFuncs.CompareTableFuncs(a,b,sFunc,Obj)
  if not a and not b then
    return
  end
  if Obj then
    return Obj[sFunc](Obj,a) < Obj[sFunc](Obj,b)
  else
    return a[sFunc](a,b) < b[sFunc](b,a)
  end
end

-- write logs funcs
local function ReplaceFunc(Name,Type,ChoGGi)
  ChoGGi.ComFuncs.SaveOrigFunc(Name)
  _G[Name] = function(...)
    ChoGGi.ComFuncs.PrintFiles(Type,ChoGGi.OrigFuncs[Name],nil,...)
  end
end
local function ResetFunc(Name,ChoGGi)
  if ChoGGi.OrigFuncs[Name] then
    _G[Name] = ChoGGi.OrigFuncs[Name]
    ChoGGi.OrigFuncs[Name] = nil
  end
end
function ChoGGi.ComFuncs.WriteLogs_Toggle(Enable)
  local ChoGGi = ChoGGi
  if Enable == true then
    --remove old logs
    local logs = "AppData/logs/"
    local console = Concat(logs,"ConsoleLog.log")
    AsyncFileRename(Concat(logs,"ConsoleLog.log"),Concat(logs,"ConsoleLog.previous.log"))
    AsyncStringToFile(console,"")

    --redirect functions
    if ChoGGi.Testing then
      ReplaceFunc("print","ConsoleLog",ChoGGi)
    end
    ReplaceFunc("AddConsoleLog","ConsoleLog",ChoGGi)
--~     ReplaceFunc("printf","DebugLog",ChoGGi)
--~     ReplaceFunc("DebugPrint","DebugLog",ChoGGi)
--~     ReplaceFunc("OutputDebugString","DebugLog",ChoGGi)
  else
    ResetFunc("AddConsoleLog",ChoGGi)
--~     ResetFunc("printf",ChoGGi)
--~     ResetFunc("DebugPrint",ChoGGi)
--~     ResetFunc("OutputDebugString",ChoGGi)
  end
end

-- ChoGGi.ComFuncs.PrintIds(Object)
function ChoGGi.ComFuncs.PrintIds(Table)
  local text = ""

  for i = 1, #Table do
    text = Concat(text,"----------------- ",Table[i].id,": ",i,"\n")
    for j = 1, #Table[i] do
      text = Concat(text,Table[i][j].id,": ",j,"\n")
    end
  end

  ChoGGi.ComFuncs.Dump(text)
end

-- check for and remove broken objects from UICity.labels
function ChoGGi.ComFuncs.RemoveMissingLabelObjects(Label)
  local UICity = UICity
  local found = true
  while found do
    found = nil
    local tab = UICity.labels[Label] or empty_table
    for i = 1, #tab do
      if not IsValid(tab[i]) then
      --if tostring(tab[i]:GetPos()) == "(0, 0, 0)" then
        table.remove(UICity.labels[Label],i)
        found = true
        break
      end
    end
  end
end

function ChoGGi.ComFuncs.RemoveMissingTableObjects(Table,TObject)
  local found = true
  while found do
    found = nil
    for i = 1, #Table do
      if TObject then
        if #Table[i][TObject] == 0 then
          table.remove(Table,i)
          found = true
          break
        end
      elseif not IsValid(Table[i]) then
        --placed objects
        table.remove(Table,i)
        found = true
        break
      end
    end
  end
  return Table
end

function ChoGGi.ComFuncs.RemoveFromLabel(Label,Obj)
  local UICity = UICity
  local tab = UICity.labels[Label] or empty_table
  for i = 1, #tab do
    if tab[i] and tab[i].handle and tab[i] == Obj.handle then
      table.remove(UICity.labels[Label],i)
    end
  end
end

function toboolean(Str)
  if Str == "true" then
    return true
  elseif Str == "false" then
    return false
  end
end

-- tries to convert "65" to 65, "boolean" to boolean, "nil" to nil
function ChoGGi.ComFuncs.RetProperType(Value)
  --number?
  local num = tonumber(Value)
  if num then
    return num
  end
  --stringy boolean
  if Value == "true" then
    return true
  elseif Value == "false" then
    return false
  end
  if Value == "nil" then
    return
  end
  --then it's a string (probably)
  return Value
end

-- used to check for some SM objects (Points/Boxes)
function ChoGGi.ComFuncs.RetType(obj)
  local meta = getmetatable(obj)
  if meta then
    if IsPoint(obj) then
      return "Point"
    end
    if IsBox(obj) then
      return "Box"
    end
  end
end

-- takes "example1 example2" and returns {[1] = "example1",[2] = "example2"}
function ChoGGi.ComFuncs.StringToTable(str)
  local Table = {}
  for i in str:gmatch("%S+") do
    Table[#Table+1] = i
  end
  return Table
end

-- change some annoying stuff about UserActions.AddActions()
local g_idxAction = 0
function ChoGGi.ComFuncs.UserAddActions(ActionsToAdd)
  if ChoGGi.Testing and type(ActionsToAdd) == "string" then
    print("ActionsToAdd",ActionsToAdd)
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

function ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon,Toolbar,Mode,xInput,ToolbarDefault)
  local ChoGGi = ChoGGi
  if Menu then
    Menu = Concat("/",tostring(Menu))
  end
  local name = "NOFUNC"
  --add name to action id
  if Action then
    local debug_info = debug.getinfo(Action, "Sn")
    local text = Concat(debug_info.short_src,"(",debug_info.linedefined,")")
    name = text:gsub(ChoGGi.ModPath,"")
    name = name:gsub(ChoGGi.ModPath:gsub("AppData","...ata"),"")
    name = name:gsub(ChoGGi.ModPath:gsub("AppData","...a"),"")
    name = name:gsub("...Mods/Expanded Cheat Menu/","")
    --
  elseif ChoGGi.Testing and Key ~= "Skip" then
    ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = Concat("<color 255 100 100>",T(302535920000000--[[Expanded Cheat Menu--]]),"</color><color 0 0 0>: </color><color 128 255 128>",T(302535920000166--[[BROKEN FUNCTION--]]),": </color>",Menu)
  end

--[[
--TEST menu items
  if Menu then
    print(Menu)
  end
  if Action then
    print(Action)
  end
  if Key then
    print(Key)
  end
  if Des then
    print(Des)
  end
  if Icon then
    print(Icon)
  end
print("\n")
--]]

  --T(Number from Game.csv)
  --UserActions.AddActions({
  --UserActions.RejectedActions()
  ChoGGi.ComFuncs.UserAddActions({
    -- AsyncRand needed for items made from same line
    [Concat("ChoGGi_",name,"-",AsyncRand())] = {
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

-- while ChoGGi.ComFuncs.CheckForTypeInList(terminal.desktop,"Examine") do
function ChoGGi.ComFuncs.CheckForTypeInList(List,Type)
  local ret = false
  for i = 1, #List do
    if List[i]:IsKindOf(Type) then
      ret = true
    end
  end
  return ret
end

--[[
ChoGGi.ComFuncs.ReturnTechAmount(Tech,Prop)
returns number from Object (so you know how much it changes)
see: Data/Object.lua, or examine(Object)

ChoGGi.ComFuncs.ReturnTechAmount("GeneralTraining","NonSpecialistPerformancePenalty")
^returns 10
ChoGGi.ComFuncs.ReturnTechAmount("SupportiveCommunity","LowSanityNegativeTraitChance")
^ returns 0.7

it returns percentages in decimal for ease of mathing (SM removed the math.functions from lua)
ie: SupportiveCommunity is -70 this returns it as 0.7
it also returns negative amounts as positive (I prefer num - Amt, not num + NegAmt)
--]]
function ChoGGi.ComFuncs.ReturnTechAmount(Tech,Prop)
  local techdef = TechDef[Tech] or empty_table
  for i = 1, #techdef do
    if techdef[i].Prop == Prop then
      Tech = techdef[i]
      local RetObj = {}

      if Tech.Percent then
        local percent = Tech.Percent
        if percent < 0 then
          percent = percent * -1 -- -50 > 50
        end
        RetObj.p = (percent + 0.0) / 100 -- (50 > 50.0) > 0.50
      end

      if Tech.Amount then
        if Tech.Amount < 0 then
          RetObj.a = Tech.Amount * -1 -- always gotta be positive
        else
          RetObj.a = Tech.Amount
        end
      end

      --With enemies you know where they stand but with Neutrals, who knows?
      if RetObj.a == 0 then
        return RetObj.p
      elseif RetObj.p == 0.0 then
        return RetObj.a
      end
    end
  end
end

--[[
  --need to see if research is unlocked
  if IsResearched and UICity:IsTechResearched(IsResearched) then
    --boolean consts
    Value = ChoGGi.ComFuncs.ReturnTechAmount(IsResearched,Name)
    --amount
    Consts["TravelTimeMarsEarth"] = Value
  end
--]]
-- function ChoGGi.ComFuncs.SetConstsG(Name,Value,IsResearched)
function ChoGGi.ComFuncs.SetConstsG(Name,Value)
  --we only want to change it if user set value
  if Value then
    --some mods change Consts or g_Consts, so we'll just do both to be sure
    Consts[Name] = Value
    g_Consts[Name] = Value
  end
end

-- if value is the same as stored then make it false instead of default value, so it doesn't apply next time
function ChoGGi.ComFuncs.SetSavedSetting(Setting,Value)
  local ChoGGi = ChoGGi
  --if setting is the same as the default then remove it
  if ChoGGi.Consts[Setting] == Value then
    ChoGGi.UserSettings[Setting] = nil
  else
    ChoGGi.UserSettings[Setting] = Value
  end
end

function ChoGGi.ComFuncs.RetTableNoDupes(Table)
  local tempt = {}
  local dupe = {}

  for i = 1, #Table do
    if not dupe[Table[i]] then
      tempt[#tempt+1] = Table[i]
      dupe[Table[i]] = true
    end
  end
  return tempt
end

function ChoGGi.ComFuncs.RetTableNoClassDupes(Table)
  local ChoGGi = ChoGGi
  table.sort(Table,
    function(a,b)
      return ChoGGi.ComFuncs.CompareTableValue(a,b,"class")
    end
  )
  local tempt = {}
  local dupe = {}

  for i = 1, #Table do
    if not dupe[Table[i].class] then
      tempt[#tempt+1] = Table[i]
      dupe[Table[i].class] = true
    end
  end
  return tempt
end

-- ChoGGi.ComFuncs.RemoveFromTable(sometable,"class","SelectionArrow")
function ChoGGi.ComFuncs.RemoveFromTable(Table,Type,Text)
  local tempt = {}
  Table = Table or empty_table
  for i = 1, #Table do
    if Table[i][Type] ~= Text then
      tempt[#tempt+1] = Table[i]
    end
  end
  return tempt
end

-- ChoGGi.ComFuncs.FilterFromTable(GetObjects{class="CObject"} or empty_table,{ParSystem=true,ResourceStockpile=true},nil,"class")
-- ChoGGi.ComFuncs.FilterFromTable(GetObjects{class="CObject"} or empty_table,nil,nil,"working")
function ChoGGi.ComFuncs.FilterFromTable(Table,ExcludeList,IncludeList,Type)
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

-- ChoGGi.ComFuncs.FilterFromTableFunc(GetObjects{class="CObject"} or empty_table,"IsKindOf","Residence")
-- ChoGGi.ComFuncs.FilterFromTableFunc(GetObjects{class="Unit"} or empty_table,"IsValid",nil,true)
function ChoGGi.ComFuncs.FilterFromTableFunc(Table,Func,Value,IsBool)
  return FilterObjects({
    filter = function(Obj)
      if IsBool then
        if _G[Func](Obj) then
          return Obj
        end
      elseif Obj[Func](Obj,Value) then
        return Obj
      end
    end
  },Table)
end

function ChoGGi.ComFuncs.OpenInMonitorInfoDlg(Table,Parent)
  if type(Table) ~= "table" then
    return
  end

  local dlg = ChoGGi_MonitorInfoDlg:new()

  if not dlg then
    return
  end

  --update internal
  dlg.object = Table
  dlg.tables = Table.tables
  dlg.values = Table.values

  dlg.idCaption:SetText(Table.title)

  --set pos
  if Parent then
    local pos = Parent:GetPos()
    if not pos then
      dlg:SetPos(terminal_GetMousePos())
    else
      dlg:SetPos(point(pos:x(),pos:y() + 22)) --22=height of header
    end
  else
    dlg:SetPos(terminal_GetMousePos())
  end
end

function ChoGGi.ComFuncs.OpenInExecCodeDlg(Object,Parent)
  if not Object then
    return
  end

  local dlg = ChoGGi_ExecCodeDlg:new()

  if not dlg then
    return
  end

  --update internal object
  dlg.obj = Object

  dlg.idCaption:SetText(ChoGGi.ComFuncs.RetName(Object))

  --set pos
  if Parent then
    local pos = Parent:GetPos()
    if not pos then
      dlg:SetPos(terminal_GetMousePos())
    else
      dlg:SetPos(point(pos:x(),pos:y() + 22)) --22=side of header
    end
  else
    dlg:SetPos(terminal_GetMousePos())
  end

end

function ChoGGi.ComFuncs.OpenInObjectManipulator(Object,Parent)
  if type(Object) ~= "table" then
    return
  end
  local ChoGGi = ChoGGi
  --nothing selected or menu item
  if not Object or (Object and not Object.class) then
    Object = ChoGGi.CodeFuncs.SelObject()
  end

  if not Object then
    return
  end

  local dlg = ChoGGi_ObjectManipulator:new()

  if not dlg then
    return
  end

  --update internal object
  dlg.obj = Object

  local title = ChoGGi.ComFuncs.RetName(Object)

  --update the add button hint
  dlg.idAddNew:SetHint(Concat(T(302535920000041--[[Add new entry to--]])," ",title," ",T(302535920000138--[[(Defaults to name/value of selected item).--]])))

  --title text
  dlg.idCaption:SetText(title)

  --set pos
  if Parent then
    local pos = Parent:GetPos()
    if not pos then
      dlg:SetPos(terminal_GetMousePos())
    else
      dlg:SetPos(point(pos:x(),pos:y() + 22)) --22=side of header
    end
  else
    dlg:SetPos(terminal_GetMousePos())
  end
  --update item list
  dlg:UpdateListContent(Object)

end

--[[
CustomType=1 : updates selected item with custom value type, hides ok/cancel buttons, dbl click opens colour changer, and sends back all items
CustomType=2 : colour selector
CustomType=3 : updates selected item with custom value type, and sends back selected item.
CustomType=4 : updates selected item with custom value type, and sends back all items
CustomType=5 : for Lightmodel: show colour selector when listitem.editor = color,pressing check2 applies the lightmodel without closing dialog, dbl rightclick shows lightmodel lists and lets you pick one to use in new window
CustomType=6 : same as 3, but dbl rightclick executes CustomFunc(selecteditem.func)

ChoGGi.ComFuncs.OpenInListChoice({
  callback = CallBackFunc,
  items = ItemList,
  title = "TitleBar",
  hint = Concat("Current",": ",hint),
  multisel = MultiSel,
  custom_type = CustomType,
  custom_func = CustomFunc,
  check1 = "Check1",
  check1_hint = "Check1Hint",
  check2 = "Check2",
  check2_hint = "Check2Hint",
})

--]]
function ChoGGi.ComFuncs.OpenInListChoice(Table)
  local ChoGGi = ChoGGi
  if not Table or (Table and type(Table) ~= "table" or not Table.callback or not Table.items) then
    MsgPopup(T(302535920000013--[[This shouldn't happen... Well shit something's bork bork bork.--]]),T(6774--[[Error--]]))
    return
  end

  --sort table by display text
  local sortby = Table.sortby or "text"
  table.sort(Table.items,
    function(a,b)
      return ChoGGi.ComFuncs.CompareTableValue(a,b,sortby)
    end
  )

  --only insert blank item if we aren't updating other items with it
  if not Table.custom_type then
    --insert blank item for adding custom value
    Table.items[#Table.items+1] = {text = "",hint = "",value = false}
  end

  CreateRealTimeThread(function()
--~     local option = ChoGGi.ComFuncs.OpenInListChoice(Table)
    local dlg = ChoGGi_ListChoiceCustomDialog:new()

    if not dlg then
      return
    end

    --title text
    dlg.idCaption:SetText(Table.title)
    --list
    dlg.idList:SetContent(Table.items)

    --fiddling with custom value
    if Table.custom_type then
      dlg.idEditValue.auto_select_all = false
      dlg.CustomType = Table.custom_type
      if Table.custom_type == 2 or Table.custom_type == 5 then
        dlg.idList:SetSelection(1, true)
        dlg.sel = dlg.idList:GetSelection()[#dlg.idList:GetSelection()]
        dlg.idEditValue:SetText(tostring(dlg.sel.value))
        dlg:UpdateColourPicker()
        if Table.custom_type == 2 then
          dlg:SetWidth(750)
          dlg.idColorHSV:SetVisible(true)
          dlg.idColorCheckAir:SetVisible(true)
          dlg.idColorCheckWater:SetVisible(true)
          dlg.idColorCheckElec:SetVisible(true)
        end
      end
    end

    if Table.custom_func then
      dlg.Func = Table.custom_func
    end

    if Table.multisel then
      dlg.idList.multiple_selection = true
      if type(Table.multisel) == "number" then
        --select all of number
        for i = 1, Table.multisel do
          dlg.idList:SetSelection(i, true)
        end
      end
    end

    --setup checkboxes
    if not Table.check1 and not Table.check2 then
      dlg.idCheckBox1:SetVisible(false)
      dlg.idCheckBox2:SetVisible(false)
    else
      dlg.idList:SetSize(point(390, 310))

      if Table.check1 then
        dlg.idCheckBox1:SetText(Table.check1)
        dlg.idCheckBox1:SetHint(Table.check1_hint)
      else
        dlg.idCheckBox1:SetVisible(false)
      end
      if Table.check2 then
        dlg.idCheckBox2:SetText(Table.check2)
        dlg.idCheckBox2:SetHint(Table.check2_hint)
      else
        dlg.idCheckBox2:SetVisible(false)
      end
    end
    --where to position dlg
    dlg:SetPos(terminal_GetMousePos())

    --focus on list
    dlg.idList:SetFocus()
    --dlg.idList:SetSelection(1, true)

    --are we showing a hint?
    if Table.hint then
      dlg.idList:SetHint(Table.hint)
      dlg.idOK:SetHint(Concat(dlg.idOK:GetHint(),"\n\n\n",Table.hint))
    end

    --hide ok/cancel buttons as they don't do jack
    if Table.custom_type == 1 then
      dlg.idOK:SetVisible(false)
      dlg.idClose:SetVisible(false)
    end

    --waiting for choice
    local option = dlg:Wait()

    if option and #option > 0 then
      Table.callback(option)
    end

  end)
end

-- returns table with list of files without path or ext and path, or exclude ext to return all files
function ChoGGi.ComFuncs.RetFilesInFolder(Folder,Ext)
  local err, files = AsyncListFiles(Folder,Ext and Concat("*",Ext) or "*")
  if not err and #files > 0 then
    local table_path = {}
    local path = Concat(Folder,"/")
    for i = 1, #files do
      local name
      if Ext then
        name = string.gsub(files[i]:gsub(path,""),Ext,"")
      else
        name = files[i]:gsub(path,"")
      end
      table_path[#table_path+1] = {
        path = files[i],
        name = name,
      }
    end
    return table_path
  end
end

function ChoGGi.ComFuncs.RetFoldersInFolder(Folder)
  --local err, folders = AsyncListFiles(Folder, "*", "recursive,folders")
  local err, folders = AsyncListFiles(Folder,"*","folders")
  if not err and #folders > 0 then
    local table_path = {}
    local temp_path = Concat(Folder,"/")
    for i = 1, #folders do
      table_path[#table_path+1] = {
        path = folders[i],
        name = folders[i]:gsub(temp_path,""),
      }
    end
    return table_path
  end
end

-- i keep forgetting this so, i'm adding it here
function ChoGGi.ComFuncs.HandleToObject(h)
  return HandleToObject[h]
end

function ChoGGi.ComFuncs.DialogUpdateMenuitems(parent)
  parent:CreateDropdownBox()

  local list = parent.list
  list:SetBackgroundColor(RGB(125,125,125))

  --of course combomenu sets the scrollbar images to blank, why not...
  list:SetScrollBackImage("CommonAssets/UI/Controls/ScrollBar/scroll_back_vertical.tga")
  list:SetScrollButtonImage("CommonAssets/UI/Controls/ScrollBar/scroll_buttons_vertical.tga")
  list:SetScrollThumbImage("CommonAssets/UI/Controls/ScrollBar/scroll_thumb_vertical.tga")

  --loop through and set hints (sure would be nice to have List do that for you)
  local windows = list.item_windows
  for i = 1, #windows do
    windows[i].orig_OnSetState = windows[i].OnSetState
    windows[i].OnSetState = function(self, list, item, rollovered, selected)
      if self.RolloverText ~= "" and (selected or rollovered) then
        CreateRolloverWindow(self.parent, self.RolloverText)
      end
      return self.orig_OnSetState(self,list, item, rollovered, selected)
    end
  end
end

-- return a string setting/text for menus
function ChoGGi.ComFuncs.SettingState(setting,msg_or_id)
  -- have it return false instead of nil
  if type(setting) == "nil" then
    setting = false
  end

  return Concat(setting,": ",T(msg_or_id))
end

-- Copyright L. H. de Figueiredo, W. Celes, R. Ierusalimschy: Lua Programming Gems
function ChoGGi.ComFuncs.VarDump(value, depth, key)
  local ChoGGi = ChoGGi
  local linePrefix = ""
  local spaces = ""
  if key ~= nil then
    linePrefix = "["..key.."] = "
  end
  if depth == nil then
    depth = 0
  else
    depth = depth + 1
    for _ = 1, depth do
      spaces = Concat(spaces," ")
    end
  end
  if type(value) == "table" then
    local mTable = getmetatable(value)
    if mTable == nil then
      print(Concat(spaces,linePrefix,"(table) "))
    else
      print(Concat(spaces,"(metatable) "))
      value = mTable
    end
    for tableKey, tableValue in pairs(value) do
      ChoGGi.ComFuncs.VarDump(tableValue, depth, tableKey)
    end
  elseif type(value) == "function"
    or type(value) == "thread"
    or type(value) == "userdata"
    or value == nil
    then
      print(Concat(spaces,tostring(value)))
  else
    print(Concat(spaces,linePrefix,"(",type(value),") ",tostring(value)))
  end
end


function ChoGGi.ComFuncs.RetBuildingPermissions(traits,settings)
  local block = false
  local restrict = false

  local rtotal = 0
  for _,_ in pairs(settings.restricttraits) do
    rtotal = rtotal + 1
  end

  local rcount = 0
  for trait,_ in pairs(traits) do
    if settings.restricttraits[trait] then
      rcount = rcount + 1
    end
    if settings.blocktraits[trait] then
      block = true
    end
  end
  --restrict is empty so allow all or since we're restricting then they need to be the same
  if not next(settings.restricttraits) or rcount == rtotal then
    restrict = true
  end

  return block,restrict
end

-- get all objects, then filter for ones within *radius*, returned sorted by dist, or *sort* for name
-- OpenExamine(ChoGGi.CodeFuncs.ReturnAllNearby(1000,"class"))
function ChoGGi.ComFuncs.ReturnAllNearby(radius,sort,pos)
  radius = radius or 5000
  pos = pos or GetTerrainCursor()

  --get all objects (18K+ on a new map)
  local all = GetObjects{} or empty_table
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

function ChoGGi.ComFuncs.RetObjectAtPos(pos,q,r)
  if pos then
    q, r = WorldToHex(pos or GetTerrainCursor())
  end
  return HexGridGetObject(ObjectGrid, q, r)
end

function ChoGGi.ComFuncs.RetObjectsAtPos(pos,q,r)
  if pos then
    q, r = WorldToHex(pos or GetTerrainCursor())
  end
  return HexGridGetObjects(ObjectGrid, q, r)
end

-- returns object name or at least always some string
function ChoGGi.ComFuncs.RetName(obj)
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
-- if i memoize and user changes the name to something then it'll return the old one
--~ ChoGGi.ComFuncs.RetName = Memoize(ChoGGi.ComFuncs.RetName)

local temp_table = {}
function ChoGGi.ComFuncs.RetSortTextAssTable(list,for_type)
  if #temp_table > 500 then
    temp_table = {}
  else
    --clean out old table instead of making a new one
    for i = #temp_table, 1, -1 do
      temp_table[i] = nil
    end
  end

  --add
  if for_type then
    for k,_ in pairs(list) do
      temp_table[#temp_table+1] = k
    end
  else
    for _,v in pairs(list) do
      temp_table[#temp_table+1] = v
    end
  end
  table.sort(temp_table)
  --and send back sorted
  return temp_table
end

function ChoGGi.ComFuncs.RetButtonTextSize(text,font,width)
  width = width or 0
  --if no font or no id for that font then default to 14 bold
  font = font and FontStyles_GetFontId(font) or FontStyles_GetFontId("Editor14Bold")
  local x,y = UIL_MeasureText(text or "", font)
  return point(x + 24 + width,y + 4) --button padding
end
ChoGGi.ComFuncs.RetButtonTextSize = Memoize(ChoGGi.ComFuncs.RetButtonTextSize)

function ChoGGi.ComFuncs.RetCheckTextSize(text,font,width)
  width = width or 0
  font = font and FontStyles_GetFontId(font) or FontStyles_GetFontId("Editor14Bold")
  local x,_ = UIL_MeasureText(text or "", font)
  return point(x + 24 + width,17) --button padding
end
ChoGGi.ComFuncs.RetCheckTextSize = Memoize(ChoGGi.ComFuncs.RetCheckTextSize)

-- Haemimont Games code from examine.lua (moved here for local)
function OpenExamine(o, from)
  local ChoGGi = ChoGGi
  if not o then
    return ChoGGi.ComFuncs.ClearShowMe()
  end

  local ex = Examine:new()
  if from then
    --i use SetPos(0,0) for all dialogs, Examine is the only one that doesn't always get set to a custom pos
    --so i use a thread in Init to re-pos it, which messes this up, so we want to make sure this is called later
    DelayedCall(1, function()
--~     CreateRealTimeThread(function()
--~       Sleep(1)
      if IsPoint(from) then
        ex:SetPos(from)

      elseif from.class == "Examine"  then
        ex:SetPos(from:GetPos() + point(0, 20))
        ex:SetSize(from:GetSize())

      else
        ex:SetPos(terminal_GetMousePos())

      end
    end)
  end
  ex:SetObj(o)
end

local OpenExamine = OpenExamine
function ex(o, from)
  if o then
    OpenExamine(o, from)
  end
end

--~ local lm = false
markers = {}
function ChoGGi.ComFuncs.ClearShowMe()
  pcall(function()
    for k, v in pairs(markers) do
      if IsValid(k) then
        if v == "point" then
          DoneObject(k)
        else
          k:SetColorModifier(v)
        end
        markers[k] = nil
      end
    end
  end)
end

local times = {}
function ChoGGi.ComFuncs.TickStart(id)
  times[id] = GetPreciseTicks()
end
function ChoGGi.ComFuncs.TickEnd(id)
  print(id,": ",GetPreciseTicks() - times[id])
  times[id] = nil
end

function ChoGGi.ComFuncs.SelectConsoleLogText()
  local dlgConsoleLog = dlgConsoleLog
  if not dlgConsoleLog then
    return
  end
  local text = dlgConsoleLog.idText:GetText()
  if text:len() == 0 then
    print(T(302535920000692--[[Log is blank (well not anymore).--]]))
    return
  end
  local dialog = ChoGGi_MultiLineText:new({}, terminal.desktop,{
  --~                 zorder = 2000001,
    wrap = true,
    text = text,
  })
  dialog:Open()
end

function ChoGGi.ComFuncs.ShowConsoleLogWin(visible)
  if visible and not dlgChoGGi_ConsoleLogWin then
    dlgChoGGi_ConsoleLogWin = ChoGGi_ConsoleLogWin:new()

    --update it with console log text
    local dlg = dlgConsoleLog
    if dlg then
      dlgChoGGi_ConsoleLogWin.idText:SetText(dlg.idText:GetText())
    else
      --if for some reason consolelog isn't around, then grab the log file
      dlgChoGGi_ConsoleLogWin.idText:SetText(select(2,AsyncFileToString(GetLogFile())))
    end

  end
  local dlg = dlgChoGGi_ConsoleLogWin
  if dlg then
    dlg:SetVisible(visible)

    --size n position
    local size = ChoGGi.UserSettings.ConsoleLogWin_Size
    local pos = ChoGGi.UserSettings.ConsoleLogWin_Pos
    --make sure dlg is within screensize
    if size then
      dlg:SetSize(size)
    end
    if pos then
      dlg:SetPos(pos)
    else
      dlg:SetPos(point(100,100))
    end

  end
end

function ChoGGi.ComFuncs.UpdateColonistsTables()
  local ChoGGi = ChoGGi
  local Nations = Nations
  local DataInstances = DataInstances

  --start off with empty ones
  ChoGGi.Tables.ColonistBirthplaces = {}
  ChoGGi.Tables.NegativeTraits = {}
  ChoGGi.Tables.PositiveTraits = {}
  ChoGGi.Tables.ColonistAges = {}
  ChoGGi.Tables.ColonistGenders = {}
  ChoGGi.Tables.ColonistSpecializations = {}

  local traits = DataInstances.Trait
  --add as index and associative tables for ease of filtering
  for i = 1, #traits do
    local cat = traits[i].category
    local name = traits[i].name
    if cat == "Positive" then
      ChoGGi.Tables.PositiveTraits[#ChoGGi.Tables.PositiveTraits+1] = name
      ChoGGi.Tables.PositiveTraits[name] = true
    elseif cat == "Negative" then
      ChoGGi.Tables.NegativeTraits[#ChoGGi.Tables.NegativeTraits+1] = name
      ChoGGi.Tables.NegativeTraits[name] = true
    elseif cat == "Age Group" then
      ChoGGi.Tables.ColonistAges[#ChoGGi.Tables.ColonistAges+1] = name
      ChoGGi.Tables.ColonistAges[name] = true
    elseif cat == "Gender" then
      ChoGGi.Tables.ColonistGenders[#ChoGGi.Tables.ColonistGenders+1] = name
      ChoGGi.Tables.ColonistGenders[name] = true
    elseif cat == "Specialization" and name ~= "none" then
      ChoGGi.Tables.ColonistSpecializations[#ChoGGi.Tables.ColonistSpecializations+1] = name
      ChoGGi.Tables.ColonistSpecializations[name] = true
    end
  end

  for i = 1, #Nations do
    ChoGGi.Tables.ColonistBirthplaces[#ChoGGi.Tables.ColonistBirthplaces+1] = Nations[i].value
    ChoGGi.Tables.ColonistBirthplaces[Nations[i].value] = true
  end

  table.sort(ChoGGi.Tables.ColonistBirthplaces)
  table.sort(ChoGGi.Tables.NegativeTraits)
  table.sort(ChoGGi.Tables.PositiveTraits)
  table.sort(ChoGGi.Tables.ColonistAges)
  table.sort(ChoGGi.Tables.ColonistGenders)
  table.sort(ChoGGi.Tables.ColonistSpecializations)
end
