--stuff only loaded when ChoGGi.Temp.Testing = true

ChoGGi.Temp.Testing = false

local cCodeFuncs = ChoGGi.CodeFuncs
local cComFuncs = ChoGGi.ComFuncs
local cConsts = ChoGGi.Consts
local cInfoFuncs = ChoGGi.InfoFuncs
local cMsgFuncs = ChoGGi.MsgFuncs
local cSettingFuncs = ChoGGi.SettingFuncs
local cTables = ChoGGi.Tables
local cOrigFuncs = ChoGGi.OrigFuncs
local cMenuFuncs = ChoGGi.MenuFuncs

--stuff that never happens, fuck comments (like this one)
if ChoGGi.Temp.Testing == 3.14 then
  for message, threads in pairs(ThreadsMessageToThreads) do
    --print(message)
    --print(threads)
    if message.action and message.action.class == "SA_WaitMsg" then
    print(message.ip)
    end
  end
  for thread in pairs(ThreadsRegister) do
    print(thread)
  end
end

if ChoGGi.Temp.Testing then
  config.TraceEnable = true
  Platform.editor = true
  config.LuaDebugger = true
  GlobalVar("outputSocket", false)
  dofile("CommonLua/Core/luasocket.lua")
  dofile("CommonLua/Core/luadebugger.lua")
  dofile("CommonLua/Core/luaDebuggerOutput.lua")
  dofile("CommonLua/Core/ProjectSync.lua")

  info = debug.getinfo

  --tell me if traits are different
  local StartupMsgs = ChoGGi.Temp.StartupMsgs
  local const = const
  local textstart = "<color 255 0 0>"
  local textend = " is different length</color>"
  if #const.SchoolTraits ~= 5 then
    StartupMsgs[#StartupMsgs+1] = textstart .. "SchoolTraits" .. textend
  end
  if #const.SanatoriumTraits ~= 7 then
    StartupMsgs[#StartupMsgs+1] = textstart .. "SanatoriumTraits" .. textend
  end
  local fulllist = TraitsCombo()
  if #fulllist ~= 55 then
    StartupMsgs[#StartupMsgs+1] = textstart .. "TraitsCombo" .. textend
  end

---------
  print("ChoGGi.Temp.Testing")
end --Testing

function cMsgFuncs.Testing_ClassesGenerate()

  ------
  print("Testing_ClassesGenerate")
end

function cMsgFuncs.Testing_ClassesPreprocess()

  ------
  print("Testing_ClassesPreprocess")
end --ClassesPreprocess

function cMsgFuncs.Testing_ClassesPostprocess()

  ------
  print("Testing_ClassesPostprocess")
end

function cMsgFuncs.Testing_ClassesBuilt()

  --stops confirmation dialog about missing mods (still lets you know they're missing)
  function GetMissingMods()
    return "", false
  end

  ------
  print("Testing_ClassesBuilt")
end

function cMsgFuncs.Testing_LoadingScreenPreClose()

  ------
  print("Testing_LoadingScreenPreClose")
end
