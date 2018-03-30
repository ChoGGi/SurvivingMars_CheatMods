--[[
dump(TupleToLuaCode(UserActions.Actions["UpsampledScreenshot"]))
dumpobject(UserActions.Actions["DE_UpsampledScreenshot"])


dump(TupleToLuaCode(dlgConsole))
dumpobject(SelectedObj)
dumptable(Consts)

list active user actions (menuitem entries)
UserActions.GetActiveActions()

--UserActions.IsActionActive(id)
UserActions.RemoveActions({
  "G_ToggleInfopanelCheats",
})
--]]
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
  os.remove(logs .. "ConsoleLog.previous.log")
  os.remove(logs .. "DebugLog.previous.log")
  os.rename(logs .. "ConsoleLog.log",logs .. "ConsoleLog.previous.log")
  os.rename(logs .. "DebugLog.log",logs .. "DebugLog.previous.log")

  --so we can pass the msgs on
  ChoGGi.OrigFunc.printf = printf
  ChoGGi.OrigFunc.AddConsoleLog = AddConsoleLog

  --replace these functions
  printf = function(...)
    ChoGGi.PrintFiles("DebugLog",ChoGGi.OrigFunc.printf,nil,...)
  end
  DebugPrint = function(...)
    ChoGGi.PrintFiles("DebugLog",nil,nil,...)
  end
  OutputDebugString = function(...)
    ChoGGi.PrintFiles("DebugLog",nil,nil,...)
  end
  AddConsoleLog = function(...)
    --we want to use our function instead of the orig to give us console history output
    ChoGGi.PrintFiles("ConsoleLog",ChoGGi.OrigFunc.AddConsoleLog,nil,...)
  end
end

function ChoGGi.Dump(Obj,Mode,File,Ext,Skip)
  Mode = Mode or "a"
  Ext = Ext or "txt"
  File = File or "DumpedText"
  local tempfile = assert(io.open("AppData/logs/" .. File .. "." .. Ext,Mode))

  if not pcall(function()
    tempfile:write(Obj)
  end) then
    pcall(function()
      tempfile:write(tostring(Obj))
    end)
  end

  tempfile:close()
  if not Skip then
    ChoGGi.MsgPopup("Dumped: " .. tostring(Obj),
      "AppData/" .. File .. "." .. Ext,"UI/Icons/Upgrades/magnetic_filtering_04.tga"
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
ChoGGi.TextFile = assert(io.open("AppData/DumpedTable.txt","w"))
ChoGGi.DumpTable(TechTree)
ChoGGi.TextFile:close()

if you want to dump functions as well DumpTable(TechTree,nil,true)
--]]
function ChoGGi.DumpTable(Obj,Mode,Funcs)
  if not Obj then
    ChoGGi.MsgPopup("Can't dump nothing",
      "Dump","UI/Icons/Upgrades/magnetic_filtering_04.tga"
    )
    return
  end
  Mode = Mode or "a"
  ChoGGi.TextFile = assert(io.open("AppData/DumpedText.txt",Mode))
  ChoGGi.DumpTableFunc(Obj,nil,Funcs)
  ChoGGi.TextFile:close()
  ChoGGi.MsgPopup("Dumped: " .. tostring(Obj),
    "AppData/DumpedText.txt","UI/Icons/Upgrades/magnetic_filtering_04.tga"
  )
end

function ChoGGi.DumpTableFunc(Obj,hierarchyLevel,Funcs)
  if (hierarchyLevel == nil) then
    hierarchyLevel = 0
  elseif (hierarchyLevel == 4) then
    return 0
  end

  if Obj.id then
    ChoGGi.TextFile:write("\n-----------------Obj.id: " .. Obj.id .. " :")
  end
  if (type(Obj) == "table") then
    for k,v in pairs(Obj) do
      if (type(v) == "table") then
        ChoGGi.DumpTableFunc(v, hierarchyLevel+1)
      else
        if k ~= nil then
          ChoGGi.TextFile:write("\n" .. tostring(k) .. " = ")
        end
--make it add the table index #
--Value: table: 0000000005FD3470
        if v ~= nil then
          ChoGGi.TextFile:write(tostring(ChoGGi.RetTextForDump(v,Funcs)))
        end
        ChoGGi.TextFile:write("\n")
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
    return tostring(Obj) .. ": " .. tostring(getmetatable(Obj) or {})
  elseif Funcs and type(Obj) == "function" then
    return "Func: \n\n" .. string.dump(Obj) .. "\n\n"
  elseif type(Obj) == "table" then
    return tostring(Obj) .. " len: " .. #Obj
  else
    return tostring(Obj)
  end
end

function ChoGGi.RemoveOldFiles()
--[[
local file_error, code = AsyncFileToString(ModPath .. "Script.lua")
if not file_error then
  ChoGGi.RemoveOldFiles()
end
--]]
  local Table = {
    "CheatMenuSettings",
    "ConsoleExec",
    "FuncsCheats",
    "FuncsDebug",
    "FuncsGameplayBuildings",
    "FuncsGameplayColonists",
    "FuncsGameplayDronesAndRC",
    "FuncsGameplayMisc",
    "FuncsResources",
    "FuncsToggles",
    "Functions",
    "MenuGameplayBuildings",
    "MenuGameplayColonists",
    "MenuGameplayDronesAndRC",
    "MenuGameplayMisc",
    "MenuToggles",
    "MenuTogglesFunc",
    "Script",
  }
  for _,Value in ipairs(Table) do
    os.remove(ChoGGi.ModPath .. Value .. ".lua")
  end
end

if ChoGGi.ChoGGiTest then
  table.insert(ChoGGi.FilesCount,"FuncDebug")
end
