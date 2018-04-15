--[[
Surviving Mars comes with
print(lfs._VERSION) LuaFileSystem 1.2 (which is weird as lfs 1.6.3 is the one with lua 5.3 support)
though SM has a bunch of AsyncFile* functions that should probably be used instead (as you can use AppData with them to specify the profile folder)

socket = require("socket")
print(socket._VERSION)
--]]

--functions (maybe) used before game is loaded

function ChoGGi.MsgPopup(Msg,Title,Icon)
  pcall(function()
    Msg = Msg or "Empty"
    --returns translated text corresponding to number if we don't do this
    if type(Msg) == "number" then
      Msg = tostring(Msg)
    end
    Title = Title or "Placeholder"
    Icon = Icon or "UI/Icons/Notifications/placeholder.tga"
    if type(AddCustomOnScreenNotification) == "function" then --incase we called it where there ain't no UI
      CreateRealTimeThread(AddCustomOnScreenNotification(
        AsyncRand(),Title,Msg,Icon,nil,{expiration=5000}
      ))
    end
  end)
end

function ChoGGi.QuestionBox(Msg,Function,Title,Ok,Cancel)
  pcall(function()
    Msg = Msg or "Empty"
    Ok = Ok or "Ok"
    Cancel = Cancel or "Cancel"
    Title = Title or "Placeholder"
    Icon = Icon or "UI/Icons/Notifications/placeholder.tga"
    CreateRealTimeThread(function()
      if "ok" == WaitQuestion(nil,
        Title,
        Msg,
        Ok,
        Cancel)
      then
        Function()
      end
    end)
  end)
end

function ChoGGi.AddAction(Menu,Action,Key,Des,Icon,Toolbar,Mode,xInput,ToolbarDefault)
  if Menu then
    Menu = "/" .. tostring(Menu)
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

  --_InternalTranslate(T({Number from Game.csv}))
  --UserActions.AddActions({
  --UserActions.RejectedActions()
  ChoGGi.UserAddActions({
    ["ChoGGi_" .. AsyncRand()] = {
      menu = Menu,
      action = Action,
      key = Key,
      description = Des or "",
      icon = Icon,
      toolbar = Toolbar,
      mode = Mode,
      xinput = xInput,
      toolbar_default = ToolbarDefault
    }
  })
end

-- positive or 1 return TrueVar || negative or 0 return FalseVar
---Consts.XXX = ChoGGi.NumRetBool(Consts.XXX,0,ChoGGi.Consts.XXX)
function ChoGGi.NumRetBool(Num,TrueVar,FalseVar)
  local Bool = true
  if Num < 1 then
    Bool = nil
  end
  return Bool and TrueVar or FalseVar
end

--return as num
function ChoGGi.BoolRetNum(Bool)
  if Bool == true then
    return 1
  end
  return 0
end

--toggle 0/1
function ChoGGi.ToggleBoolNum(Num)
  if Num == 0 then
    return 1
  end
  return 0
end

--return equal or higher amount
function ChoGGi.CompareAmounts(iAmtA,iAmtB)
  if iAmtA >= iAmtB then
    return iAmtA
  elseif iAmtB >= iAmtA then
    return iAmtB
  end
end

function ChoGGi.PrintFiles(Filename,Function,Text,...)
  Text = Text or ""
  --pass ... onto pcall function
  local Variadic = ...
  pcall(function()
    ChoGGi.Dump(Text .. Variadic .. "\r\n","a",Filename,"log",true)
  end)
  if Function then
    Function(...)
  end
end

function ChoGGi.WriteLogsEnable()
  --remove old logs
  local logs = "AppData/logs/"
  AsyncFileDelete(logs .. "ConsoleLog.log")
  AsyncFileDelete(logs .. "DebugLog.log")
  AsyncFileRename(logs .. "ConsoleLog.log",logs .. "ConsoleLog.previous.log")
  AsyncFileRename(logs .. "DebugLog.log",logs .. "DebugLog.previous.log")

  --redirect functions
  ChoGGi.OrigFunc.AddConsoleLog = AddConsoleLog
  AddConsoleLog = function(...)
    ChoGGi.PrintFiles("ConsoleLog",ChoGGi.OrigFunc.AddConsoleLog,nil,...)
  end
  ChoGGi.OrigFunc.printf = printf
  printf = function(...)
    ChoGGi.PrintFiles("DebugLog",ChoGGi.OrigFunc.printf,nil,...)
  end
  --these only show up in the usual log afer you exit the game (or maybe never if it crashes)
  ChoGGi.OrigFunc.DebugPrint = DebugPrint
  DebugPrint = function(...)
    ChoGGi.PrintFiles("DebugLog",ChoGGi.OrigFunc.DebugPrint,nil,...)
  end
  ChoGGi.OrigFunc.OutputDebugString = OutputDebugString
  OutputDebugString = function(...)
    ChoGGi.PrintFiles("DebugLog",ChoGGi.OrigFunc.OutputDebugString,nil,...)
  end
end

function ChoGGi.Dump(Obj,Mode,File,Ext,Skip)
  if Mode == "w" or Mode == "w+" then
    Mode = nil
  else
    Mode = "-1"
  end
  Ext = Ext or "txt"
  File = File or "DumpedText"
  local Filename = "AppData/logs/" .. File .. "." .. Ext
  --local tempfile = assert(io.open("AppData/logs/" .. File .. "." .. Ext,Mode))

  if not pcall(function()
    AsyncStringToFile(Filename,Obj,Mode)
    --tempfile:write(Obj)
  end) then
    pcall(function()
      AsyncStringToFile(Filename,Obj,Mode)
      --tempfile:write(tostring(Obj))
    end)
  end

  --tempfile:close()
  if not Skip then
    ChoGGi.MsgPopup("Dumped: " .. tostring(Obj),
      Filename,"UI/Icons/Upgrades/magnetic_filtering_04.tga"
    )
  end
end

--ChoGGi.PrintIds(TechTree)
function ChoGGi.PrintIds(Table)
  local text = ""
  for i,_ in ipairs(Table) do
    text = text .. "----------------- " .. Table[i].id .. ": " .. i .. "\n"
    for j,_ in ipairs(Table[i]) do
      text = text .. Table[i][j].id .. ": " .. j .. "\n"
    end
  end
  ChoGGi.Dump(text)
end

--[[
Mode = -1 to append or nil to overwrite (default: -1)
Funcs = true to dump functions as well (default: false)
ChoGGi.DumpTable(TechTree)
--]]
function ChoGGi.DumpTable(Obj,Mode,Funcs)
  if not Obj then
    ChoGGi.MsgPopup("Can't dump nothing",
      "Dump","UI/Icons/Upgrades/magnetic_filtering_04.tga"
    )
    return
  end
  Mode = Mode or "-1"
  --make sure it's empty
  ChoGGi.TextFile = ""
  ChoGGi.DumpTableFunc(Obj,nil,Funcs)
  AsyncStringToFile("AppData/logs/DumpedTable.txt",ChoGGi.TextFile,Mode)

  ChoGGi.MsgPopup("Dumped: " .. tostring(Obj),
    "AppData/logs/DumpedText.txt","UI/Icons/Upgrades/magnetic_filtering_04.tga"
  )
end

function ChoGGi.DumpTableFunc(Obj,hierarchyLevel,Funcs)
  if (hierarchyLevel == nil) then
    hierarchyLevel = 0
  elseif (hierarchyLevel == 4) then
    return 0
  end

  if Obj.id then
    ChoGGi.TextFile = ChoGGi.TextFile .. "\n-----------------Obj.id: " .. Obj.id .. " :"
    --ChoGGi.TextFile:write()
  end
  if (type(Obj) == "table") then
    for k,v in pairs(Obj) do
      if (type(v) == "table") then
        ChoGGi.DumpTableFunc(v, hierarchyLevel+1)
      else
        if k ~= nil then
          ChoGGi.TextFile = ChoGGi.TextFile .. "\n" .. tostring(k) .. " = "
          --ChoGGi.TextFile:write("\n" .. tostring(k) .. " = ")
        end
--make it add the table index #
--Value: table: 0000000005FD3470
        if v ~= nil then
          ChoGGi.TextFile = ChoGGi.TextFile .. tostring(ChoGGi.RetTextForDump(v,Funcs))
          --ChoGGi.TextFile:write(tostring(ChoGGi.RetTextForDump(v,Funcs)))
        end
        ChoGGi.TextFile = ChoGGi.TextFile .. "\n"
        --ChoGGi.TextFile:write("\n")
      end
    end
  end
end

--[[
ChoGGi.DumpObject(Consts)
ChoGGi.DumpObject(const)
if you want to dump functions as well DumpObject(object,true)
--]]
function ChoGGi.DumpObject(Obj,Mode,Funcs)
  if not Obj then
    ChoGGi.MsgPopup("Can't dump nothing",
      "Dump","UI/Icons/Upgrades/magnetic_filtering_04.tga"
    )
    return
  end

  local Text = ""
  for k,v in pairs(Obj) do
    if k ~= nil then
      Text = Text .. "\n" .. tostring(k) .. " = "
    end
    if v ~= nil then
      Text = Text .. tostring(ChoGGi.RetTextForDump(v,Funcs))
    end
    --Text = Text .. "\n"
  end
  ChoGGi.Dump(Text,Mode)
--[[
  tech = ""
  for k,i in ipairs(Obj) do
    tech = tech .. ChoGGi.RetTextForDump(k[i]) .. "\n"
  end
  tech = tech .. "\n\n\n"
  ChoGGi.Dump(tech)
--]]
end

function ChoGGi.RetTextForDump(Obj,Funcs)
  if type(Obj) == "userdata" then
    return function()
      _InternalTranslate(Obj)
    end
  elseif Funcs and type(Obj) == "function" then
    return "Func: \n\n" .. string.dump(Obj) .. "\n\n"
  elseif type(Obj) == "table" then
    return tostring(Obj) .. " len: " .. #Obj
  else
    return tostring(Obj)
  end
end
