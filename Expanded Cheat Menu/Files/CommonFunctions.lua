--See LICENSE for terms

local oldTableConcat = oldTableConcat

--[[
Surviving Mars comes with
print(lfs._VERSION) LuaFileSystem 1.2 (which is weird as lfs 1.6.3 is the one with lua 5.3 support)
though SM has a bunch of AsyncFile* functions that should probably be used instead (as you can use AppData with them to specify the profile folder)
lpeg v0.10


socket = require("socket")
print(socket._VERSION)
--]]

function ChoGGi.ComFuncs.Trans(...)
  local data = select(1,...)
  local trans
  local vararg = {...}
  pcall(function()
    if type(data) == "userdata" then
       trans = _InternalTranslate(table.unpack(vararg))
    else
      trans = _InternalTranslate(T({table.unpack(vararg)}))
    end
  end)
  --just incase
  if type(trans) ~= "string" then
    return type(vararg[2]) == "string" and vararg[2] or "ERROR"
  end
  return trans
end

function ChoGGi.ComFuncs.MsgPopup(Msg,Title,Icon,Size)
  local AddCustomOnScreenNotification = AddCustomOnScreenNotification
  --if we called it where there ain't no UI
  if type(AddCustomOnScreenNotification) ~= "function" then
    return
  end
  local ChoGGi = ChoGGi
  Icon = type(tostring(Icon):find(".tga")) == "number" and Icon or oldTableConcat({ChoGGi.MountPath,"TheIncal.tga"})
  --we only use the id to remove it below (don't want a big 'ol list in g_ShownOnScreenNotifications)
  local id = AsyncRand()
  local timeout = 10000
  if Size then
    timeout = 30000
  end
  CreateRealTimeThread(function()
    AddCustomOnScreenNotification(
      --Msg: returns translated text corresponding to number if we don't do tostring for numbers
      id,tostring(Title or ""),tostring(Msg or ChoGGi.ComFuncs.Trans(3718,"NONE")),Icon,nil,{expiration=timeout}
      --id,Title,Msg,Icon,nil,{expiration=99999999999999999}
    )
    --since I use AsyncRand for the id, I don't want this getting too large.
    g_ShownOnScreenNotifications[id] = nil
    --large amount of text option
    if Size then
      --add some custom settings this way, till i figure out hwo to add them as params
      local osDlg = GetXDialog("OnScreenNotificationsDlg")[1]
      local popup
      for i = 1, #osDlg do
        if osDlg[i].notification_id == id then
          popup = osDlg[i]
          break
        end
      end
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
      if "ok" == WaitQuestion(nil,
        tostring(Title or ""),
        tostring(Msg or ""),
        tostring(Ok or ChoGGi.ComFuncs.Trans(6878,"OK")),
        tostring(Cancel or ChoGGi.ComFuncs.Trans(6879,"Cancel"))
      ) then
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
  local Filename = oldTableConcat({"AppData/logs/",File,".",Ext})

  if pcall(function()
    ThreadLockKey(Filename)
    AsyncStringToFile(Filename,Obj,Mode)
    ThreadUnlockKey(Filename)
  end) then
    if not Skip then
      ChoGGi.ComFuncs.MsgPopup(oldTableConcat({ChoGGi.ComFuncs.Trans(302535920000002,"Dumped"),": ",tostring(Obj)}),
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
  ChoGGi.ComFuncs.Dump(oldTableConcat({"\r\n",_G[which](Value)}),nil,"DumpedLua","lua")
end

--[[
Mode = -1 to append or nil to overwrite (default: -1)
Funcs = true to dump functions as well (default: false)
ChoGGi.ComFuncs.DumpTable(Object)
--]]
function ChoGGi.ComFuncs.DumpTable(Obj,Mode,Funcs)
  local ChoGGi = ChoGGi
  if not Obj then
    ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000003,"Can't dump nothing"),ChoGGi.ComFuncs.Trans(302535920000004,"Dump"))
    return
  end
  Mode = Mode or "-1"
  --make sure it's empty
  ChoGGi.TextFile = ""
  ChoGGi.ComFuncs.DumpTableFunc(Obj,nil,Funcs)
  AsyncStringToFile("AppData/logs/DumpedTable.txt",ChoGGi.TextFile,Mode)

  ChoGGi.ComFuncs.MsgPopup(oldTableConcat({ChoGGi.ComFuncs.Trans(302535920000002,"Dumped"),": ",tostring(Obj)}),"AppData/logs/DumpedText.txt")
end

function ChoGGi.ComFuncs.DumpTableFunc(Obj,hierarchyLevel,Funcs)
  local ChoGGi = ChoGGi
  if (hierarchyLevel == nil) then
    hierarchyLevel = 0
  elseif (hierarchyLevel == 4) then
    return 0
  end

  if Obj.id then
    ChoGGi.TextFile = oldTableConcat({ChoGGi.TextFile,"\n-----------------Obj.id: ",Obj.id," :"})
  end
  if (type(Obj) == "table") then
    for k,v in pairs(Obj) do
      if (type(v) == "table") then
        ChoGGi.ComFuncs.DumpTableFunc(v, hierarchyLevel+1)
      else
        if k ~= nil then
          ChoGGi.TextFile = oldTableConcat({ChoGGi.TextFile,"\n",tostring(k)," = "})
        end
        if v ~= nil then
          ChoGGi.TextFile = oldTableConcat({ChoGGi.TextFile,tostring(ChoGGi.ComFuncs.RetTextForDump(v,Funcs))})
        end
        ChoGGi.TextFile = oldTableConcat({ChoGGi.TextFile,"\n"})
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
    ChoGGi.ComFuncs.MsgPopup(ChoGGi.ComFuncs.Trans(302535920000003,"Can't dump nothing"),ChoGGi.ComFuncs.Trans(302535920000004,"Dump"))
    return
  end

  local Text = ""
  for k,v in pairs(Obj) do
    if k ~= nil then
      Text = oldTableConcat({Text,"\n",tostring(k)," = "})
    end
    if v ~= nil then
      Text = oldTableConcat({Text,tostring(ChoGGi.ComFuncs.RetTextForDump(v,Funcs))})
    end
  end
  ChoGGi.ComFuncs.Dump(Text,Mode)
end

function ChoGGi.ComFuncs.RetTextForDump(Obj,Funcs)
  if type(Obj) == "userdata" then
    return ChoGGi.ComFuncs.Trans(Obj)
  elseif Funcs and type(Obj) == "function" then
    return oldTableConcat({"Func: \n\n",string.dump(Obj),"\n\n"})
  elseif type(Obj) == "table" then
    return oldTableConcat({tostring(Obj)," len: ",#Obj})
  else
    return tostring(Obj)
  end
end

function ChoGGi.ComFuncs.PrintFiles(Filename,Function,Text,...)
  Text = Text or ""
  --pass ... onto pcall function
  local vararg = ...
  pcall(function()
    ChoGGi.ComFuncs.Dump(oldTableConcat({Text,vararg,"\r\n"}),Filename,"log",true)
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

function ChoGGi.ComFuncs.WriteLogs_Toggle(Enable)
  local ChoGGi = ChoGGi
  if Enable == true then
    --remove old logs
    local logs = "AppData/logs/"
    AsyncFileDelete(oldTableConcat({logs,"ConsoleLog.log"}))
    AsyncFileDelete(oldTableConcat({logs,"DebugLog.log"}))
    AsyncFileRename(oldTableConcat({logs,"ConsoleLog.log"}),oldTableConcat({logs,"ConsoleLog.previous.log"}))
    AsyncFileRename(oldTableConcat({logs,"DebugLog.log"}),oldTableConcat({logs,"DebugLog.previous.log"}))

    --redirect functions
    local function ReplaceFunc(Name,Type)
      ChoGGi.ComFuncs.SaveOrigFunc(Name)
      _G[Name] = function(...)
        ChoGGi.ComFuncs.PrintFiles(Type,ChoGGi.OrigFuncs[Name],nil,...)
      end
    end
    ReplaceFunc("AddConsoleLog","ConsoleLog")
    ReplaceFunc("printf","DebugLog")
    ReplaceFunc("DebugPrint","DebugLog")
    ReplaceFunc("OutputDebugString","DebugLog")
  else
    local function ResetFunc(Name)
      if ChoGGi.OrigFuncs[Name] then
        _G[Name] = ChoGGi.OrigFuncs[Name]
        ChoGGi.OrigFuncs[Name] = nil
      end
    end
    ResetFunc("AddConsoleLog")
    ResetFunc("printf")
    ResetFunc("DebugPrint")
    ResetFunc("OutputDebugString")
  end
end

--ChoGGi.ComFuncs.PrintIds(Object)
function ChoGGi.ComFuncs.PrintIds(Table)
  local text = ""

  for i = 1, #Table do
    text = oldTableConcat({text,"----------------- ",Table[i].id,": ",i,"\n"})
    for j = 1, #Table[i] do
      text = oldTableConcat({text,Table[i][j].id,": ",j,"\n"})
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
    return ChoGGi.OrigFuncs[oldTableConcat({ClassName,"_",FuncName})](...)
  end
end

--backup orginal function for later use (checks if we already have a backup, or else problems)
function ChoGGi.ComFuncs.SaveOrigFunc(ClassOrFunc,Func)
  local ChoGGi = ChoGGi
  if Func then
    local newname = oldTableConcat({ClassOrFunc,"_",Func})
    if not ChoGGi.OrigFuncs[newname] then
      ChoGGi.OrigFuncs[newname] = _G[ClassOrFunc][Func]
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
  local IsValid = IsValid
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
  local IsValid = IsValid
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
do --RetType
  local IsPoint = IsPoint
  local IsBox = IsBox
  function ChoGGi.CodeFuncs.RetType(Obj)
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
end

--takes "example1 example2" and returns {[1] = "example1",[2] = "example2"}
function ChoGGi.ComFuncs.StringToTable(String)
  local Table = {}
  for i in String:gmatch("%S+") do
    Table[#Table+1] = i
  end
  return Table
end

--change some annoying stuff about UserActions.AddActions()
local g_idxAction = 0
function ChoGGi.ComFuncs.UserAddActions(ActionsToAdd)
  local UserActions = UserActions
  for k, v in pairs(ActionsToAdd) do
    if type(v.action) == "function" and (v.key ~= nil and v.key ~= "" or v.xinput ~= nil and v.xinput ~= "" or v.menu ~= nil and v.menu ~= "" or v.toolbar ~= nil and v.toolbar ~= "") then
      if v.key ~= nil and v.key ~= "" then
        if type(v.key) == "table" then
          local keys = v.key
          if #keys <= 0 then
            v.description = ""
          else
            v.description = oldTableConcat({v.description," (",keys[1]})
            for i = 2, #keys do
              v.description = oldTableConcat({v.description," ",ChoGGi.ComFuncs.Trans(302535920000165,"or")," ",keys[i]})
            end
            v.description = oldTableConcat({v.description,")"})
          end
        else
          v.description = oldTableConcat({tostring(v.description)," (",v.key,")"})
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
  UserActions.SetMode(UserActions.mode)
end

function ChoGGi.ComFuncs.AddAction(Menu,Action,Key,Des,Icon,Toolbar,Mode,xInput,ToolbarDefault)
  local ChoGGi = ChoGGi
  if Menu then
    Menu = oldTableConcat({"/",tostring(Menu)})
  end
  local name = "NOFUNC"
  --add name to action id
  local Temp = ChoGGi.Temp
  if Action then
    local debug_info = debug.getinfo(Action, "Sn")
    local text = tostring(oldTableConcat({debug_info.short_src,"(",debug_info.linedefined,")"}))
    name = text:gsub(ChoGGi.ModPath,"")
    name = name:gsub(ChoGGi.ModPath:gsub("AppData","...ata"),"")
    name = name:gsub(ChoGGi.ModPath:gsub("AppData","...a"),"")
    --
  elseif Temp.Testing and Key ~= "Skip" then
    Temp.StartupMsgs[#Temp.StartupMsgs+1] = oldTableConcat({"<color 255 100 100>",ChoGGi.ComFuncs.Trans(302535920000000,"Expanded Cheat Menu"),"</color><color 0 0 0>: </color><color 128 255 128>",ChoGGi.ComFuncs.Trans(302535920000166,"BROKEN FUNCTION"),": </color>",Menu})
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

  --ChoGGi.ComFuncs.Trans(Number from Game.csv)
  --UserActions.AddActions({
  --UserActions.RejectedActions()
  ChoGGi.ComFuncs.UserAddActions({
    [oldTableConcat({"ChoGGi_",name,"-",AsyncRand()})] = {
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
  local techdef = TechDef[Tech]

  local tab = techdef or empty_table
  for i = 1, #tab do
    if tab[i].Prop == Prop then
      Tech = tab[i]
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

--ChoGGi.ComFuncs.RemoveFromTable(sometable,"class","SelectionArrow")
function ChoGGi.ComFuncs.RemoveFromTable(Table,Type,Text)
  local tempt = {}

  local tab = Table or empty_table
  for i = 1, #tab do
    if tab[i][Type] ~= Text then
      tempt[#tempt+1] = tab[i]
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

function ChoGGi.ComFuncs.OpenExamineAtExPosOrMouse(Obj,ObjPos)
  --examine will offset to ObjPos
  if ObjPos then
    OpenExamine(Obj,ObjPos)
  else
    --i want to open it at mouse pos
    local ex = Examine:new()
    ex:SetObj(Obj)
    ex:SetPos(terminal.GetMousePos())
  end
  return ex
end
function ChoGGi.ComFuncs.OpenInMonitorInfoDlg(Table,Parent)
  if not Table then
    return
  end
  local ChoGGi = ChoGGi

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
      dlg:SetPos(terminal.GetMousePos())
    else
      dlg:SetPos(point(pos:x(),pos:y() + 22)) --22=height of header
    end
  else
    dlg:SetPos(terminal.GetMousePos())
  end
end

function ChoGGi.ComFuncs.OpenInExecCodeDlg(Object,Parent)
  if not Object then
    return
  end
  local ChoGGi = ChoGGi

  local dlg = ChoGGi_ExecCodeDlg:new()

  if not dlg then
    return
  end

  --update internal object
  dlg.obj = Object

  local title = tostring(Object)
  if type(Object) == "table" and Object.class then
    title = oldTableConcat({"Class: ",Object.class})
  end

  --title text
  if type(Object) == "table" then
    dlg.idCaption:SetText(oldTableConcat({ChoGGi.ComFuncs.Trans(302535920000040,"Exec Code on"),": ",(Object.class or tostring(Object))}))
  end

  --set pos
  if Parent then
    local pos = Parent:GetPos()
    if not pos then
      dlg:SetPos(terminal.GetMousePos())
    else
      dlg:SetPos(point(pos:x(),pos:y() + 22)) --22=side of header
    end
  else
    dlg:SetPos(terminal.GetMousePos())
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

  local title = ChoGGi.CodeFuncs.RetName(Object)

  --update the add button hint
  dlg.idAddNew:SetHint(oldTableConcat({ChoGGi.ComFuncs.Trans(302535920000041,"Add new entry to")," ",title," ",ChoGGi.ComFuncs.Trans(302535920000138,"(Defaults to name/value of selected item).")}))

  --title text
  dlg.idCaption:SetText(title)

  --set pos
  if Parent then
    local pos = Parent:GetPos()
    if not pos then
      dlg:SetPos(terminal.GetMousePos())
    else
      dlg:SetPos(point(pos:x(),pos:y() + 22)) --22=side of header
    end
  else
    dlg:SetPos(terminal.GetMousePos())
  end
  --update item list
  dlg:UpdateListContent(Object)

end

--returns table with list of files without path or ext and path, or exclude ext to return all files
function ChoGGi.ComFuncs.RetFilesInFolder(Folder,Ext)
  local err, files = AsyncListFiles(Folder,Ext and oldTableConcat({"*",Ext}) or "*")
  if not err and #files > 0 then
    local table_path = {}
    local path = oldTableConcat({Folder,"/"})
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

--rebuild menu toolbar buttons
function ChoGGi.ComFuncs.RebuildConsoleToolbar(host)
  local XAction = XAction
  host = host or terminal.desktop

  --clear out old menu/toolbar items
  for i = #host.actions, 1, -1 do
    if host.actions[i].ChoGGi_ConsoleAction or
        host:FilterAction(host.actions[i]) and host.actions[i].ActionMenubar:find("ChoGGi_") then
      host.actions[i]:delete()
      table.remove(host.actions,i)
    end
  end

  XAction:new({
    ActionId = "ChoGGi_Scripts",
    ActionMenubar = "Menu",
    ActionName = ChoGGi.ComFuncs.Trans(302535920000353,"Scripts"),
    OnActionEffect = "popup",
    ChoGGi_ConsoleAction = true,
  }, dlgConsole)

  XAction:new({
    ActionId = "ChoGGi_History",
    ActionMenubar = "Menu",
    ActionName = ChoGGi.ComFuncs.Trans(302535920000793,"History"),
    OnActionEffect = "popup",
    ChoGGi_ConsoleAction = true,
  }, dlgConsole)

  local folders = ChoGGi.ComFuncs.RetFoldersInFolder(ChoGGi.scripts)
  if folders then
    for i = 1, #folders do
      XAction:new({
        ActionId = oldTableConcat({"ChoGGi_",folders[i].name}),
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
    local temp_path = oldTableConcat({Folder,"/"})
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
  local AsyncFileToString = AsyncFileToString
  local XAction = XAction

  --create folder and some example scripts if folder doesn't exist
  if main and AsyncFileOpen(script_path) ~= "Access Denied" then
    AsyncCreatePath(script_path)
    --print some info
    print(oldTableConcat({"Place .lua files in ",script_path," to have them show up in the \"Scripts\" list, you can then use the list to execute them (you can also create folders for sorting)."}))
    --add some example files and a readme
    AsyncStringToFile(oldTableConcat({script_path,"/readme.txt","Any .lua files in here will be part of a list that you can execute in-game from the console menu."}))
    AsyncStringToFile(oldTableConcat({script_path,"/Help.lua","Place .lua files in ",script_path," to have them show up in the 'Scripts' list, you can then use the list to execute them (you can also create folders for sorting)."}))
    AsyncCreatePath(oldTableConcat({script_path,"/Examine"}))
    AsyncStringToFile(oldTableConcat({script_path,"/Examine/DataInstances.lua","OpenExamine(DataInstances)"}))
    AsyncStringToFile(oldTableConcat({script_path,"/Examine/InGameInterface.lua","OpenExamine(GetInGameInterface())"}))
    AsyncStringToFile(oldTableConcat({script_path,"/Examine/terminal.desktop.lua","OpenExamine(terminal.desktop)"}))
    AsyncCreatePath(oldTableConcat({script_path,"/Functions"}))
    AsyncStringToFile(oldTableConcat({script_path,"/Functions/Amount of colonists.lua","#GetObjects({class=\"Colonist\"})"}))
    AsyncStringToFile(oldTableConcat({script_path,"/Functions/Toggle Working SelectedObj.lua","SelectedObj:ToggleWorking()"}))
    --rebuild toolbar
    ChoGGi.ComFuncs.RebuildConsoleToolbar()
  end

  local scripts = ChoGGi.ComFuncs.RetFilesInFolder(script_path,".lua")
  if scripts then
    for i = 1, #scripts do
      XAction:new({
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

function ChoGGi.ComFuncs.NewThread(Func,...)
  coroutine.resume(coroutine.create(Func),...)
end

function ChoGGi.ComFuncs.DialogAddCaption(self,Table)
  self.idCaption = StaticText:new(self)
  self.idCaption:SetPos(Table.pos)
  self.idCaption:SetSize(Table.size)
  self.idCaption:SetHSizing("AnchorToLeft")
  --self.idCaption:SetVSizing("Resize")
  self.idCaption:SetBackgroundColor(0)
  self.idCaption:SetFontStyle("Editor14Bold")
  self.idCaption:SetTextPrefix(Table.prefix or "<center>")
  self.idCaption.HandleMouse = false
  --self.idCaption.SingleLine = true
end

function ChoGGi.ComFuncs.DialogAddCloseX(self,func)
  self.idCloseX = Button:new(self)
  self.idCloseX:SetHSizing("AnchorToRight")
  self.idCloseX:SetPos(self:GetPos() + point(self:GetSize():x() - 21, 3))
  self.idCloseX:SetSize(point(18, 18))
  self.idCloseX:SetImage("CommonAssets/UI/Controls/Button/Close.tga")
  self.idCloseX:SetHint(T({1011, "Close"}))
  self.idCloseX.OnButtonPressed = func or function()
    self:delete()
  end
end
