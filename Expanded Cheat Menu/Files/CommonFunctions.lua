--See LICENSE for terms

--~ Surviving Mars comes with
--~ print(lfs._VERSION) LuaFileSystem 1.2 (which is weird as lfs 1.6.3 is the one with lua 5.3 support)
--~ though SM has a bunch of AsyncFile* functions that should probably be used instead (as you can use AppData with them to specify the profile folder)

--~ lpeg v0.10 : lpeg.version()
--~ require("leg.grammar") --LPeg grammar manipulation
--~ require("leg.parser") --LPeg Lua parser

--~ socket = require("socket")
--~ print(socket._VERSION)

--[[
local function MemoizeTextTESTING(func)
  local stored_queries = {}
  setmetatable(stored_queries, {__mode = "kv"})
  return function(...)
    local ret = stored_queries[...]
    if ret == nil then
      ret = func(...)
      stored_queries[...] = ret
    end
    print("\nMemoizeTextTESTING: ",ret,"\n")
    return ret
  end
end
--]]

local Concat = ChoGGi.ComFuncs.Concat --added in Init.lua

local getmetatable,setmetatable = getmetatable,setmetatable
local next,pairs,print,type,select = next,pairs,print,type,select
local pcall,tonumber,tostring = pcall,tonumber,tostring

local table,string = table,string
local table_remove,table_sort,table_unpack,table_set_defaults = table.remove,table.sort,table.unpack,table.set_defaults
local debug_getinfo,string_dump,string_gsub = debug.getinfo,string.dump,string.gsub

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
local ShowConsoleLog = ShowConsoleLog
local Sleep = Sleep
local TechDef = TechDef
local ThreadLockKey = ThreadLockKey
local ThreadUnlockKey = ThreadUnlockKey
local ViewPos = ViewPos
local WaitMarsQuestion = WaitMarsQuestion
local WaitPopupNotification = WaitPopupNotification

local T = T --T replaced below
local guic = guic

local UserActions_SetMode = UserActions.SetMode
local terminal_GetMousePos = terminal.GetMousePos
local UIL_MeasureText = UIL.MeasureText
local terrain_IsPointInBounds = terrain.IsPointInBounds

local g_Classes = g_Classes

local memoize = {
  _VERSION     = 'memoize v2.0',
  _DESCRIPTION = 'Memoized functions in Lua',
  _URL         = 'https://github.com/kikito/memoize.lua',
  _LICENSE     = [[
    MIT LICENSE

    Copyright (c) 2018 Enrique Garc??ota

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

    return table_unpack(results)
  end
end
setmetatable(memoize, { __call = function(_, ...) return memoize.memoize(...) end })
ChoGGi.ComFuncs.MemoizeText = memoize.memoize
local MemoizeText = memoize.memoize

--cache translation strings (doesn't work well with _InternalTranslate)
IsT = MemoizeText(IsT)
T = MemoizeText(T)
TDevModeGetEnglishText = MemoizeText(TDevModeGetEnglishText)

--I want a translate func to always return a string
function ChoGGi.ComFuncs.Trans(...)
  local trans
  local vararg = {...}
  --just incase a
  pcall(function()
    if type(vararg[1]) == "userdata" then
      trans = _InternalTranslate(table_unpack(vararg))
    else
      trans = _InternalTranslate(T(vararg))
    end
  end)
  --just incase b
  if type(trans) ~= "string" then
    if type(vararg[2]) == "string" then
      return vararg[2]
    end
    return Concat("ERROR",AsyncRand())
  end
  return trans
end
ChoGGi.ComFuncs.Trans = MemoizeText(ChoGGi.ComFuncs.Trans)
local T = ChoGGi.ComFuncs.Trans

--shows a popup msg with the rest of the notifications
function ChoGGi.ComFuncs.MsgPopup(Msg,Title,Icon,Size)
  local ChoGGi = ChoGGi
  Icon = type(tostring(Icon):find(".tga")) == "number" and Icon or Concat(ChoGGi.MountPath,"TheIncal.tga")
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
  table_set_defaults(data, params)
  table_set_defaults(data, OnScreenNotificationPreset)

  CreateRealTimeThread(function()
		local popup = g_Classes.OnScreenNotification:new({}, dlg.idNotifications)
		popup:FillData(data, nil, params, cycle_objs)
		popup:Open()
		dlg:ResolveRelativeFocusOrder()
    --large amount of text option
    if Size then
      --remove text limit
      --popup.idText.Shorten = false
      --popup.idText.MaxHeight = nil
      popup.idText.Margins = box(0,0,0,-500)
      --resize
      popup.idTitle.Margins = box(0,-20,0,0)
      --image
      Sleep(0)
      popup[1].scale = point(2800,2600)
      popup[1].Margins = box(-5,-30,0,-5)
      --update dialog
      popup:InvalidateMeasure()
--parent ex(GetXDialog("OnScreenNotificationsDlg")[1])
--osn GetXDialog("OnScreenNotificationsDlg")[1][1]
      --[[
      if type(params.fx_action) == "string" and params.fx_action ~= "" then
        PlayFX(params.fx_action)
      end
      --]]
    end
  end)
end

--centred msgbox with Ok
function ChoGGi.ComFuncs.MsgWait(Msg,Title)
  Title = Title or ""
  CreateRealTimeThread(
    WaitPopupNotification,
    false,
    {title = tostring(Title), text = tostring(Msg)}
  )
end

--well that's the question isn't it?
function ChoGGi.ComFuncs.QuestionBox(Msg,Function,Title,Ok,Cancel)
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
      ChoGGi.ComFuncs.MsgPopup(Concat(T(302535920000002--[[Dumped--]]),": ",tostring(Obj)),
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
    ChoGGi.ComFuncs.MsgPopup(T(302535920000003--[[Can't dump nothing--]]),T(302535920000004--[[Dump--]]))
    return
  end
  Mode = Mode or "-1"
  --make sure it's empty
  ChoGGi.TextFile = ""
  ChoGGi.ComFuncs.DumpTableFunc(Obj,nil,Funcs)
  AsyncStringToFile("AppData/logs/DumpedTable.txt",ChoGGi.TextFile,Mode)

  ChoGGi.ComFuncs.MsgPopup(Concat(T(302535920000002--[[Dumped--]]),": ",ChoGGi.ComFuncs.RetName(Obj)),
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
    ChoGGi.ComFuncs.MsgPopup(T(302535920000003--[[Can't dump nothing--]]),T(302535920000004--[[Dump--]]))
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
    return Concat("Func: \n\n",string_dump(Obj),"\n\n")
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

--[[
positive or 1 return TrueVar || negative or 0 return FalseVar
ChoGGi.Consts.XXX = ChoGGi.ComFuncs.NumRetBool(ChoGGi.Consts.XXX,0,ChoGGi.Consts.XXX)
--]]
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

--return opposite value or first value if neither
function ChoGGi.ComFuncs.ValueRetOpp(Setting,Value1,Value2)
  if Setting == Value1 then
    return Value2
  elseif Setting == Value2 then
    return Value1
  end
  --just in case
  return Value1
end

--return as num
function ChoGGi.ComFuncs.BoolRetNum(Bool)
  if Bool == true then
    return 1
  end
  return 0
end

--toggle 0/1
function ChoGGi.ComFuncs.ToggleBoolNum(Num)
  if Num == 0 then
    return 1
  end
  return 0
end

--return equal or higher amount
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

--compares two values, if types are different then makes them both strings
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
  table_sort(Items,
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
table_sort(s.command_centers,
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

--write logs funcs
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
    AsyncFileDelete(Concat(logs,"ConsoleLog.log"))
    AsyncFileDelete(Concat(logs,"DebugLog.log"))
    AsyncFileRename(Concat(logs,"ConsoleLog.log"),Concat(logs,"ConsoleLog.previous.log"))
    AsyncFileRename(Concat(logs,"DebugLog.log"),Concat(logs,"DebugLog.previous.log"))

    --redirect functions
    ReplaceFunc("AddConsoleLog","ConsoleLog",ChoGGi)
    ReplaceFunc("printf","DebugLog",ChoGGi)
    ReplaceFunc("DebugPrint","DebugLog",ChoGGi)
    ReplaceFunc("OutputDebugString","DebugLog",ChoGGi)
  else
    ResetFunc("AddConsoleLog",ChoGGi)
    ResetFunc("printf",ChoGGi)
    ResetFunc("DebugPrint",ChoGGi)
    ResetFunc("OutputDebugString",ChoGGi)
  end
end

--ChoGGi.ComFuncs.PrintIds(Object)
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

--changes a function to also post a Msg for use with OnMsg
function ChoGGi.ComFuncs.AddMsgToFunc(ClassName,FuncName,sMsg)
  local ChoGGi = ChoGGi
  --save orig
  ChoGGi.ComFuncs.SaveOrigFunc(ClassName,FuncName)
  --redefine it
  _G[ClassName][FuncName] = function(...)
    --I just care about adding self to the msgs
    Msg(sMsg,select(1,...))
    --pass on args to orig func
    return ChoGGi.OrigFuncs[Concat(ClassName,"_",FuncName)](...)
  end
end

--backup orginal function for later use (checks if we already have a backup, or else problems)
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

--check for and remove broken objects from UICity.labels
function ChoGGi.ComFuncs.RemoveMissingLabelObjects(Label)
  local UICity = UICity
  local found = true
  while found do
    found = nil
    local tab = UICity.labels[Label] or empty_table
    for i = 1, #tab do
      if not IsValid(tab[i]) then
      --if tostring(tab[i]:GetPos()) == "(0, 0, 0)" then
        table_remove(UICity.labels[Label],i)
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
          table_remove(Table,i)
          found = true
          break
        end
      elseif not IsValid(Table[i]) then
        --placed objects
        table_remove(Table,i)
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
      table_remove(UICity.labels[Label],i)
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

--tries to convert "65" to 65, "boolean" to boolean, "nil" to nil
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

--used to check for some SM objects (Points/Boxes)
function ChoGGi.ComFuncs.RetType(Obj)
  local meta = getmetatable(Obj)
  if meta then
    if IsPoint(Obj) then
      return "Point"
    end
    if IsBox(Obj) then
      return "Box"
    end
  end
end

--takes "example1 example2" and returns {[1] = "example1",[2] = "example2"}
function ChoGGi.ComFuncs.StringToTable(str)
  local Table = {}
  for i in str:gmatch("%S+") do
    Table[#Table+1] = i
  end
  return Table
end

--change some annoying stuff about UserActions.AddActions()
local g_idxAction = 0
function ChoGGi.ComFuncs.UserAddActions(ActionsToAdd)
if ChoGGi.Temp.Testing then
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

function ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon,Toolbar,Mode,xInput,ToolbarDefault)
  local ChoGGi = ChoGGi
  if Menu then
    Menu = Concat("/",tostring(Menu))
  end
  local name = "NOFUNC"
  --add name to action id
  if Action then
    local debug_info = debug_getinfo(Action, "Sn")
    local text = tostring(Concat(debug_info.short_src,"(",debug_info.linedefined,")"))
    name = text:gsub(ChoGGi.ModPath,"")
    name = name:gsub(ChoGGi.ModPath:gsub("AppData","...ata"),"")
    name = name:gsub(ChoGGi.ModPath:gsub("AppData","...a"),"")
    --
  elseif ChoGGi.Temp.Testing and Key ~= "Skip" then
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

--while ChoGGi.ComFuncs.CheckForTypeInList(terminal.desktop,"Examine") do
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
--function ChoGGi.ComFuncs.SetConstsG(Name,Value,IsResearched)
function ChoGGi.ComFuncs.SetConstsG(Name,Value)
  --we only want to change it if user set value
  if Value then
    --some mods change Consts or g_Consts, so we'll just do both to be sure
    Consts[Name] = Value
    g_Consts[Name] = Value
  end
end

--if value is the same as stored then make it false instead of default value, so it doesn't apply next time
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
  table_sort(Table,
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

--ChoGGi.ComFuncs.RemoveFromTable(sometable,"class","SelectionArrow")
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

--ChoGGi.ComFuncs.FilterFromTable(GetObjects({class="CObject"}),{ParSystem=true,ResourceStockpile=true},nil,"class")
--ChoGGi.ComFuncs.FilterFromTable(GetObjects({class="CObject"}),nil,nil,"working")
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

--ChoGGi.ComFuncs.FilterFromTableFunc(GetObjects({class="CObject"}),"IsKindOf","Residence")
--ChoGGi.ComFuncs.FilterFromTableFunc(GetObjects({class="Unit"}),"IsValid",nil,true)
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

  local dlg = g_Classes.ChoGGi_MonitorInfoDlg:new()

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

  local dlg = g_Classes.ChoGGi_ExecCodeDlg:new()

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

  local dlg = g_Classes.ChoGGi_ObjectManipulator:new()

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

--returns table with list of files without path or ext and path, or exclude ext to return all files
function ChoGGi.ComFuncs.RetFilesInFolder(Folder,Ext)
  local err, files = AsyncListFiles(Folder,Ext and Concat("*",Ext) or "*")
  if not err and #files > 0 then
    local table_path = {}
    local path = Concat(Folder,"/")
    for i = 1, #files do
      local name
      if Ext then
        name = string_gsub(files[i]:gsub(path,""),Ext,"")
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

--rebuild menu toolbar buttons
function ChoGGi.ComFuncs.RebuildConsoleToolbar(host)
  host = host or terminal.desktop
  local ChoGGi = ChoGGi
  local dlgConsole = dlgConsole

  --clear out old menu/toolbar items
  for i = #host.actions, 1, -1 do
    if host.actions[i].ChoGGi_ConsoleAction or
        host:FilterAction(host.actions[i]) and host.actions[i].ActionMenubar:find("ChoGGi_") then
      host.actions[i]:delete()
      table_remove(host.actions,i)
    end
  end

  g_Classes.XAction:new({
    ActionId = "ChoGGi_Scripts",
    ActionMenubar = "Menu",
    ActionName = T(302535920000353--[[Scripts--]]),
    OnActionEffect = "popup",
    ChoGGi_ConsoleAction = true,
  }, dlgConsole)

  g_Classes.XAction:new({
    ActionId = "ChoGGi_History",
    ActionMenubar = "Menu",
    ActionName = T(302535920000793--[[History--]]),
    OnActionEffect = "popup",
    ChoGGi_ConsoleAction = true,
  }, dlgConsole)

  local folders = ChoGGi.ComFuncs.RetFoldersInFolder(ChoGGi.scripts)
  if folders then
    for i = 1, #folders do
      g_Classes.XAction:new({
        ActionId = Concat("ChoGGi_",folders[i].name),
        ActionMenubar = "Menu",
        ActionName = folders[i].name,
        OnActionEffect = "popup",
        ChoGGi_ConsoleAction = true,
      }, dlgConsole)
    end
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

--used to add files to Script menu
function ChoGGi.ComFuncs.ListScriptFiles(menu_name,script_path,main)
  local ChoGGi = ChoGGi
  local dlgConsole = dlgConsole

  --create folder and some example scripts if folder doesn't exist
  if main and AsyncFileOpen(script_path) ~= "Access Denied" then
    AsyncCreatePath(script_path)
    --print some info
    local help = Concat(T(302535920000881--[[Place .lua files in--]])," ",script_path," ",T(302535920000882--[[to have them show up in the 'Scripts' list, you can then use the list to execute them (you can also create folders for sorting).--]]))
    print(help)
    --add some example files and a readme
    AsyncStringToFile(Concat(script_path,"/readme.txt"),T(302535920000888--[[Any .lua files in here will be part of a list that you can execute in-game from the console menu.--]]))
    AsyncStringToFile(Concat(script_path,"/Help.lua"),help)
    AsyncCreatePath(Concat(script_path,"/Examine"))
    AsyncStringToFile(Concat(script_path,"/Examine/XTemplates.lua"),"OpenExamine(XTemplates)")
    AsyncStringToFile(Concat(script_path,"/Examine/DataInstances.lua"),"OpenExamine(DataInstances)")
    AsyncStringToFile(Concat(script_path,"/Examine/InGameInterface.lua"),"OpenExamine(GetInGameInterface())")
    AsyncStringToFile(Concat(script_path,"/Examine/terminal.desktop.lua"),"OpenExamine(terminal.desktop)")
    AsyncStringToFile(Concat(script_path,"/Examine/ChoGGi.lua"),"OpenExamine(ChoGGi)")
    AsyncCreatePath(Concat(script_path,"/Functions"))
    AsyncStringToFile(Concat(script_path,"/Functions/Amount of colonists.lua"),"#GetObjects({class=\"Colonist\")")
    AsyncStringToFile(Concat(script_path,"/Functions/Toggle Working SelectedObj.lua"),"SelectedObj:ToggleWorking()")
    --rebuild toolbar
    ChoGGi.ComFuncs.RebuildConsoleToolbar()
  end

  local scripts = ChoGGi.ComFuncs.RetFilesInFolder(script_path,".lua")
  if scripts then
    for i = 1, #scripts do
      g_Classes.XAction:new({
        ActionId = scripts[i].name,
        ActionMenubar = menu_name,
        ActionName = scripts[i].name,
        --ActionIcon = "CommonAssets/UI/Ged/new.tga",
        OnAction = function()
          local file_error, script = AsyncFileToString(scripts[i].path)
          if not file_error then
            --print(scripts[i])
            --make sure log is showing
            ShowConsoleLog(true)
            dlgConsole:Exec(script)
          end
        end
      }, dlgConsole)
    end
  end
end

--i keep forgetting this so, i'm adding it here
function ChoGGi.ComFuncs.HandleToObject(h)
  return HandleToObject[h]
end

function ChoGGi.ComFuncs.DialogAddCaption(parent,Table)
  parent.idCaption = g_Classes.StaticText:new(parent)
  parent.idCaption:SetPos(Table.pos)
  parent.idCaption:SetSize(Table.size)
  parent.idCaption:SetHSizing("AnchorToLeft")
  parent.idCaption:SetBackgroundColor(0)
  parent.idCaption:SetFontStyle("Editor14Bold")
  parent.idCaption:SetTextPrefix(Table.prefix or "<center>")
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

function ChoGGi.ComFuncs.DialogAddMenuItem(name,parent,hint,obj)
  local item = g_Classes.StaticText:new(parent)
  item:SetText(name)
  item.rollover = hint
  item.obj = obj
  parent:AddItem(item)
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

--return a string setting/text for menus
function ChoGGi.ComFuncs.SettingState(setting,msg_or_id)

  if setting == false or type(setting) == "nil" then
    setting = "false"
--~   elseif setting == true then
--~     setting = "true"
  elseif type(setting) == "number" or type(setting) == "string" then
    setting = setting
  else
    setting = "true"
  end

  return Concat(setting,": ",T(msg_or_id))
end

--Copyright L. H. de Figueiredo, W. Celes, R. Ierusalimschy: Lua Programming Gems
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

--get all objects, then filter for ones within *Radius*, returned sorted by dist, or *Sort* for name
--OpenExamine(ChoGGi.CodeFuncs.ReturnAllNearby(1000,"class"))
function ChoGGi.ComFuncs.ReturnAllNearby(Radius,Sort)
  Radius = Radius or 5000
  local pos = GetTerrainCursor()

  --get pretty much all objects (18K on a new map)
  local all = GetObjects({class="CObject"})
  --we only want stuff within *Radius*
  local list = FilterObjects({
    filter = function(Obj)
      if Obj:GetDist2D(pos) <= Radius then
        return Obj
      end
    end
  },all)

  --sort list custom
  if Sort then
    table_sort(list,
      function(a,b)
        return a[Sort] < b[Sort]
      end
    )
  else
    --sort nearest
    table_sort(list,
      function(a,b)
        return a:GetDist2D(pos) < b:GetDist2D(pos)
      end
    )
  end
  return list
end

--returns object name or at least always some string
function ChoGGi.ComFuncs.RetName(obj)
  if obj == _G then
    return "_G"
  end
  local is_table = type(obj) == "table"
  local name
  --translated name
  if is_table then
    if obj.display_name then
      return T(obj.display_name)
    elseif IsObjlist(obj) then
      return "objlist"
    end
    name = obj.encyclopedia_id or obj.class
  end

  if type(name) == "string" then
    return name
  end

  --falling back baby (lags the shit outta kansas if this is a large objlist)
  return tostring(obj)
end
ChoGGi.ComFuncs.RetName = MemoizeText(ChoGGi.ComFuncs.RetName)

local temp_table = {}
function ChoGGi.ComFuncs.RetSortTextAssTable(list,for_type)
  --clean out old table instead of making a new one
  for i = #temp_table, 1, -1 do
    temp_table[i] = nil
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
  table_sort(temp_table)
  --and send back sorted
  return temp_table
end

function ChoGGi.ComFuncs.RetButtonTextSize(text,font)
  font = font and FontStyles.GetFontId(font) or FontStyles.GetFontId("Editor14Bold")
  local x,y = UIL_MeasureText(text or "", font)
  return point(x + 24,y + 4) --button padding
end
ChoGGi.ComFuncs.RetButtonTextSize = MemoizeText(ChoGGi.ComFuncs.RetButtonTextSize)

function ChoGGi.ComFuncs.RetCheckTextSize(text,font)
  font = font and FontStyles.GetFontId(font) or FontStyles.GetFontId("Editor14Bold")
  local x,_ = UIL_MeasureText(text or "", font)
  return point(x + 24,17) --button padding
end
ChoGGi.ComFuncs.RetCheckTextSize = MemoizeText(ChoGGi.ComFuncs.RetCheckTextSize)

--Haemimont Games code from examine.lua (moved here for local)
function OpenExamine(o, from)
  local ChoGGi = ChoGGi
  if o == nil then
    return ChoGGi.ComFuncs.ClearShowMe()
  end

  local ex = g_Classes.Examine:new()
  if from then
    --i use SetPos(0,0) for all dialogs, Examine is the only one that doesn't always get set to a custom pos
    --so i use a thread in Init to re-pos it, which of course messes this up, so we make sure this is called later
    CreateRealTimeThread(function()
      Sleep(1)
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
  OpenExamine(o, from)
end
function ChoGGi.ComFuncs.ClearShowMe()
  for k, v in pairs(markers) do
    if IsValid(k) then
      if v == "point" then
        DoneObject(k)
      else
--~         if v == 65280 then --marker green
--~           k:SetColorModifier(6579300)
--~         else
          k:SetColorModifier(v)
--~         end
      end
    end
  end
--~   if Platform.developer then
--~     ClearTextTrackers()
--~   end
end
--~ local lm = false
markers = {}
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
--~   elseif not markers[o] then
--~     AddTrackerText(false, o)
  end
--~   lm = o

  --never gets called
--~   if time then
--~     CreateGameTimeThread(function()
--~       Sleep(time)
--~       local v = markers[o]
--~       if IsValid(o) then
--~         if v == "point" or v == "vector" then
--~           DoneObject(o)
--~         else
--~           o:SetColorModifier(v)
--~         end
--~       end
--~       if Platform.developer then
--~         ClearTextTrackers(o)
--~       end
--~     end)
--~   end

end
function ChoGGi.ComFuncs.ShowCircle(pt, r, color)
  local c = g_Classes.Circle:new()
  c:SetPos(pt:SetTerrainZ(10 * guic))
  c:SetRadius(r)
  c:SetColor(color or RGB(255, 255, 255))
  CreateGameTimeThread(function()
    Sleep(7000)
    if IsValid(c) then
--~       c:delete()
      DoneObject(c)
    end
  end)
end
function ChoGGi.ComFuncs.StartDebugger()
  config.Haerald = {
    platform = GetDebuggeePlatform(),
    ip = "localhost",
    RemoteRoot = "",
    ProjectFolder = "",
  }
  SetupRemoteDebugger(
    config.Haerald.ip,
    config.Haerald.RemoteRoot,
    config.Haerald.ProjectFolder
  )
  StartDebugger()
--~   ProjectSync()
end

local times = {}
function ChoGGi.ComFuncs.TickStart(id)
  times[id] = GetPreciseTicks()
end
function ChoGGi.ComFuncs.TickEnd(id)
  print(id,": ",GetPreciseTicks() - times[id])
  times[id] = nil
end
