-- This must return true for most cheats to function
function CheatsEnabled()
  return true
end

--keep my mod contained in
ChoGGi = {
  SettingsFileLoaded = false,
  SettingsFile = "AppData/CheatMenuModSettings.lua",
  ModPath = "AppData/Mods/CheatMod_CheatMenu/",
}
--used to let me know if any files didn't load
local file_error, code = AsyncFileToString("AppData/ChoGGi.lua")
if not file_error then
  ChoGGi.ChoGGiComp = true
end

--msgs file (OnMsg.DataLoaded, GameLoaded, etc)
dofile(ChoGGi.ModPath .. "OnMsgs.lua")
--my functions
dofile(ChoGGi.ModPath .. "FuncDebug.lua")
dofile(ChoGGi.ModPath .. "FuncGame.lua")
--saved settings from this mod
dofile(ChoGGi.ModPath .. "Settings.lua")
--reading settings from AppData/CheatMenuModSettings.lua
ChoGGi.ReadSettings()
--people will just copy new mod over old, and I renamed some stuff
local file_error, code = AsyncFileToString(ChoGGi.ModPath .. "Script.lua")
if not file_error then
  ChoGGi.RemoveOldFiles()
end


--Platform.ged = true
--Platform.cmdline = true
--config.Network = true
--config.LuaDebugger = true
--upsampled screenshot
-- Turn on editor mode (this is required for cheats to work) and then add the editor commands
Platform.editor = true
Platform.developer = true
Platform.cmdline = true
--add built-in cheat menu items
AddCheatsUA()

--buildings menu (kinda useless, but what the haeh)
dofile("Lua/Buildings/Building.lua")
--dbg_DrainAllDrones(),dbg_TestForDetached(),dbg_TestRockets(),dbg_GetDetachedDrone()
dofile("Lua/Units/Drone.lua")
--Toggle Hex Build Grid Visibility
dofile("Lua/hex.lua")
--add ConsoleExec
--[[
dlgConsole.autoCompleteList = true
dlgConsole.cursorPosOnTabPress = true
dlgConsole.autoCompleteListPos = true
dlgConsole.autoCompleteCursorPosOnLastUpdate = true
dlgConsole.autoCompleteTextOnLastUpdate = true
--]]
dofile("CommonLua/console.lua")
dofile("CommonLua/UI/Dev/uiConsole.lua")
dofile("CommonLua/UI/Dev/uiConsoleLog.lua")


--output results to console
ConsolePrint = ChoGGi.AddConsoleLog
ChoGGi.print = print
print = ChoGGi.AddConsoleLog
--make some easy to type names
function console(...)
  ConsolePrint(tostring(...))
end
con = console
log = ChoGGi.Dump
dump = ChoGGi.Dump
dumpobject = ChoGGi.DumpObject
dumpo = ChoGGi.DumpObject
dumptable = ChoGGi.DumpTable
dumpt = ChoGGi.DumpTable
alert = ChoGGi.MsgPopup
function dumplua(...)
  ChoGGi.Dump(TupleToLuaCode(...))
end
dumpl = dumplua
exit = quit
function restart()
  quit("restart")
end

--we want dev mode left on?
if not ChoGGi.CheatMenuSettings.developer then
  Platform.developer = false
end

--block CheatEmpty from working?
if ChoGGi.CheatMenuSettings.BlockCheatEmpty then
  ChoGGi.SetBlockCheatEmpty()
end

--[[
o:test()  -- method call. equivalent to o.test(o)
o.test()  -- regular function call. similar to just test()
o.x = 5   -- field access

function ChoGGi.ExamineInitNew()
  self.onclick_handles = {}
  self.obj = false
  self.show_times = "relative"
  self.offset = 1
  self.page = 1
  self.transp_mode = transp_mode
  function self.idText.OnHyperLink(_, link, _, box, pos, button)
    self.onclick_handles[tonumber(link)](box, pos, button)
  end
  self.idText:AddInterpolation({
    type = const.intAlpha,
    startValue = 255,
    flags = const.intfIgnoreParent
  })
  function self.idMenu.OnHyperLink(_, link, _, box, pos, button)
    self.onclick_handles[tonumber(link)](box, pos, button)
  end
  self.idMenu:AddInterpolation({
    type = const.intAlpha,
    startValue = 255,
    flags = const.intfIgnoreParent
  })
  function self.idNext.OnButtonPressed()
    ChoGGi.Dump(self.idFilter:GetText())
    --self:FindNext(self.idFilter:GetText())
  end
  self.idFilter:AddInterpolation({
    type = const.intAlpha,
    startValue = 255,
    flags = const.intfIgnoreParent
  })
  function self.idFilter.OnValueChanged(this, value)
    self:FindNext(value)
  end
  function self.idFilter.OnKbdKeyDown(_, char, virtual_key)
    if virtual_key == const.vkEnter then
      self:FindNext(self.idFilter:GetText())
      return "break"
    end
    StaticText.OnKbdKeyDown(self, char, virtual_key)
  end
  function self.idClose.OnButtonPressed()
    self:delete()
  end
  self:SetTranspMode(self.transp_mode)
end

Examine = ChoGGi.ExamineInitNew
--]]


--if we toggled debuglog option
if ChoGGi.WriteDebugLogs then
  AddConsoleLog("ChoGGi: WriteDebugLogs",true)
  ChoGGi.WriteDebugLogsEnable()
end

--load up custom actions (menus/keys)
dofile(ChoGGi.ModPath .. "Keys.lua")
dofile(ChoGGi.ModPath .. "MenuBuildingsFunc.lua")
dofile(ChoGGi.ModPath .. "MenuBuildings.lua")
dofile(ChoGGi.ModPath .. "MenuCheatsFunc.lua")
dofile(ChoGGi.ModPath .. "MenuCheats.lua")
dofile(ChoGGi.ModPath .. "MenuColonistsFunc.lua")
dofile(ChoGGi.ModPath .. "MenuColonists.lua")
dofile(ChoGGi.ModPath .. "MenuDebugFunc.lua")
dofile(ChoGGi.ModPath .. "MenuDebug.lua")
dofile(ChoGGi.ModPath .. "MenuDronesAndRCFunc.lua")
dofile(ChoGGi.ModPath .. "MenuDronesAndRC.lua")
dofile(ChoGGi.ModPath .. "MenuMiscFunc.lua")
dofile(ChoGGi.ModPath .. "MenuMisc.lua")
dofile(ChoGGi.ModPath .. "MenuResourcesFunc.lua")
dofile(ChoGGi.ModPath .. "MenuResources.lua")
dofile(ChoGGi.ModPath .. "MenuTogglesFunc.lua")
dofile(ChoGGi.ModPath .. "MenuToggles.lua")

--change some default menu items
UserActions.RemoveActions({
  --useless without developer tools?
  "BuildingEditor",
  --these will switch the map without asking to save
  "G_ModsEditor",
  "G_OpenPregameMenu",
  --added to toggles menu
  "G_ToggleInfopanelCheats",
})
--move some items around
--UserActions.Actions["DE_Screenshot"].menu = "[999]Help/[105]Screenshot"
--UserActions.Actions["DE_UpsampledScreenshot"].menu = "[999]Help/[106]Upsampled Screenshot"
UserActions.Actions["DE_Screenshot"].menu = "Help/Screenshot"
UserActions.Actions["DE_UpsampledScreenshot"].menu = "Help/Upsampled Screenshot"
--update menu
UAMenu.UpdateUAMenu(UserActions.GetActiveActions())

if ChoGGi.ChoGGiComp then
  AddConsoleLog("ChoGGi: Init.lua",true)
end
