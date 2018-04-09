--[[
Surviving Mars comes with
print(lfs._VERSION) LuaFileSystem 1.2 (which is weird as lfs 1.6.3 is the one with lua 5.3 support)

socket = require("socket")
print(socket._VERSION)

--see where the function comes from
debug.getinfo(ChoGGi.RemoveOldFiles)

--zoom in on obj
local obj = SelectedObj
local center, radius = obj:GetBSphere()
local min, max = cameraRTS.GetZoomLimits()
ViewObjectMars(obj, nil, nil, Clamp(radius / 2, min, max))

SelectedObj:__toluacode()

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
  AsyncFileDelete(logs .. "ConsoleLog.log")
  AsyncFileDelete(logs .. "DebugLog.log")
  AsyncFileRename(logs .. "ConsoleLog.log",logs .. "ConsoleLog.previous.log")
  AsyncFileRename(logs .. "DebugLog.log",logs .. "DebugLog.previous.log")

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

--hex rings
do
  local build_grid_debug_range = 10
  GlobalVar("build_grid_debug_objs", false)
  GlobalVar("build_grid_debug_thread", false)
  function ChoGGi.debug_build_grid()
    if build_grid_debug_thread then
      DeleteThread(build_grid_debug_thread)
      build_grid_debug_thread = false
      if build_grid_debug_objs then
        for i = 1, #build_grid_debug_objs do
          DoneObject(build_grid_debug_objs[i])
        end
        build_grid_debug_objs = false
      end
    else
      build_grid_debug_objs = {}
      build_grid_debug_thread = CreateRealTimeThread(function()
        local last_q, last_r
        while build_grid_debug_objs do
          local q, r = WorldToHex(GetTerrainCursor())
          if last_q ~= q or last_r ~= r then
            local z = -q - r
            local idx = 1
            for q_i = q - build_grid_debug_range, q + build_grid_debug_range do
              for r_i = r - build_grid_debug_range, r + build_grid_debug_range do
                for z_i = z - build_grid_debug_range, z + build_grid_debug_range do
                  if q_i + r_i + z_i == 0 then
                    local c = build_grid_debug_objs[idx] or Circle:new()
                    c:SetRadius(const.GridSpacing / 2)
                    c:SetPos(point(HexToWorld(q_i, r_i)))
                    if HexGridGetObject(ObjectGrid, q_i, r_i) then
                      c:SetColor(RGBA(255, 0, 0, 0))
                    else
                      c:SetColor(RGBA(0, 255, 0, 0))
                    end
                    build_grid_debug_objs[idx] = c
                    idx = idx + 1
                  end
                end
              end
            end
            last_q = q
            last_r = r
          end
          Sleep(50)
        end
      end)
    end
  end
end

if ChoGGi.Testing then
  table.insert(ChoGGi.FilesCount,"FuncDebug")
end
