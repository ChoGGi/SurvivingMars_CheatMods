--keep everything stored in
ChoGGi = {
  email = "ECM@choggi.org",
  id = "ChoGGi_CheatMenu",
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  --orig funcs that we replace
  OrigFuncs = {},
  --CommonFunctions.lua
  ComFuncs = {},
  --/Code/_Functions.lua
  CodeFuncs = {},
  --/Code/*Menu.lua and /Code/*Func.lua
  MenuFuncs = {},
  --OnMsgs.lua
  MsgFuncs = {},
  --InfoPaneCheats.lua
  InfoFuncs = {},
  --Defaults.lua
  SettingFuncs = {},
  --temporary settings that aren't saved to SettingsFile
  Temp = {
    --collect msgs to be displayed when game is loaded
    StartupMsgs = {},
    --list of dustdevil handles we've shot at
    DefenceTowerRocketDD = {},
    --same
    ShuttleRocketDD = {},
    --controllable shuttle handles launched (true = attacker, false = friend)
    CargoShuttleThreads = {},
    --we just want one shuttle scanning per anomaly (list of anomaly handles that are being scanned)
    CargoShuttleScanningAnomaly = {},
    --handles of units we're placing waypoints for (keys=handles,values=threads)
    UnitPathingHandles = {},
  },
  --settings that are saved to SettingsFile
  UserSettings = {
    BuildingSettings = {},
    Transparency = {},
  },
}

do
  local ChoGGi = ChoGGi
  local Mods = Mods
  ChoGGi._VERSION = Mods[ChoGGi.id].version
  ChoGGi.ModPath = Mods[ChoGGi.id].path

  --if we use global func more then once: make them local for that small bit o' speed
  local AsyncFileToString = AsyncFileToString
  local dofolder_files = dofolder_files

  --used to let me know if we're on my computer
  local file_error, _ = AsyncFileToString("AppData/ChoGGi")
  if not file_error then
    ChoGGi.Temp.Testing = true
  end

  if ChoGGi.Temp.Testing then
    --get saved settings for this mod
    dofile(ChoGGi.ModPath .. "Files/Defaults.lua")
    --functions needed before Code/ is loaded
    dofile(ChoGGi.ModPath .. "Files/CommonFunctions.lua")
    --load all the other files
    dofolder_files(ChoGGi.ModPath .. "Files/Code")
  else
    --if file exists then we'll ignore Files.hpk (user likely unpacked the files)
    local file_error, _ = AsyncFileToString(ChoGGi.ModPath .. "/Defaults.lua")
    if not file_error then
      --get saved settings for this mod
      dofile(ChoGGi.ModPath .. "/Defaults.lua")
      --functions needed for before Code/ is loaded
      dofile(ChoGGi.ModPath .. "/CommonFunctions.lua")
      --load all the other files
      dofolder_files(ChoGGi.ModPath .. "/Code")
    else
      local MountName = "ChoGGi_Mount"
      --load up the hpk
      AsyncMountPack(MountName,ChoGGi.ModPath .. "/Files.hpk")
      dofile(MountName .. "/Defaults.lua")
      dofile(MountName .. "/CommonFunctions.lua")
      dofolder_files(MountName .. "/Code")
      --and unload it
      Unmount(MountName)
    end
  end
end

--read settings from AppData/CheatMenuModSettings.lua
ChoGGi.SettingFuncs.ReadSettings()

--okay i doubt i'm using local correctly
local ChoGGi = ChoGGi

--bloody hint popups
if ChoGGi.UserSettings.DisableHints then
  mapdata.DisableHints = true
  HintsEnabled = false
end

--why would anyone ever turn this off? console logging ftw, and why did the devs make their log print only after quitting...!? unless of course it crashes in certain ways, then fuck you no log for you... it's all about thinking your design decisions through. wrap your file writes in a thread or something, but at least write it during gameplay please and thanks...... some more ... just for good measure, enjoyed the rant?
if ChoGGi.Temp.Testing then
  ChoGGi.UserSettings.WriteLogs = true
end

--if writelogs option
if ChoGGi.UserSettings.WriteLogs == true then
  ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = "<color 200 200 200>ECM</color><color 0 0 0>: </color><color 128 255 128>Writing debug/console logs to AppData/logs</color>"
  ChoGGi.ComFuncs.WriteLogs_Toggle(ChoGGi.UserSettings.WriteLogs)
end

--first time run info
if ChoGGi.UserSettings.FirstRun ~= false then
  ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = "<color 200 200 200>\nECM Active<color 0 0 0>:</color></color><color 128 255 128>\nF2 to toggle cheats menu\nDebug>Console Toggle History to toggle this console history.</color>\n\n\n"
  ChoGGi.UserSettings.FirstRun = false
  ChoGGi.Temp.WriteSettings = true
end

local Platform = Platform
Platform.developer = true
Platform.editor = true
--fixes UpdateInterface nil value in editor mode
editor.LoadPlaceObjConfig()
--some error it gives about missing table
GlobalVar("g_revision_map",{})
Platform.developer = false
Platform.editor = false

--be nice to get a remote debugger working
--[[
Platform.editor = true
config.LuaDebugger = true
GlobalVar("outputSocket", false)
dofile("CommonLua/Core/luasocket.lua")
dofile("CommonLua/Core/luadebugger.lua")
dofile("CommonLua/Core/luaDebuggerOutput.lua")
dofile("CommonLua/Core/ProjectSync.lua")
config.LuaDebugger = false
Platform.editor = false
--]]
--[[
ClassesGenerate
ClassesPreprocess
ClassesPostprocess
ClassesBuilt
OptionsApply
Autorun
ModsLoaded
EntitiesLoaded
BinAssetsLoaded
--]]
