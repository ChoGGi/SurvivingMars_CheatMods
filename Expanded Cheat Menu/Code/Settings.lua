-- See LICENSE for terms

-- stores default values and some tables

local next, pairs, type, table, os = next, pairs, type, table, os

local LuaCodeToTuple = LuaCodeToTuple
local TableToLuaCode = TableToLuaCode
local SaveLocalStorage = SaveLocalStorage
local ThreadLockKey = ThreadLockKey
local ThreadUnlockKey = ThreadUnlockKey

-- used for loading/saving settings
local function PrintError(err)
	local err_str = Strings[302535920000000--[[Expanded Cheat Menu]]] .. ": " .. Strings[302535920000243--[[Problem saving settings! Error: %s]]]:format(err)
	if ChoGGi.Temp.GameLoaded then
		print(err_str)
	else
		ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = err_str
	end
end

--~ local Translate = ChoGGi.ComFuncs.Translate
local Strings = ChoGGi.Strings
local blacklist = ChoGGi.blacklist
local testing = ChoGGi.testing

local AsyncFileToString = not blacklist and AsyncFileToString
local AsyncCopyFile = not blacklist and AsyncCopyFile
local AsyncStringToFile = not blacklist and AsyncStringToFile

-- stores defaults
ChoGGi.Defaults = {
	-- updated when saved
	_SAVED = 0,
	-- okay, maybe some people don't want a mod to change the title of their game
	ChangeWindowTitle = true,
	-- removes some useless crap from the Cheats section (unless you're doing the tutorial then not as useless it seems)
	CleanupCheatsInfoPane = true,
	-- dark background for the console log
	ConsoleDim = true,
	-- shows LUA ERRORs in console along with stack
	ConsoleErrors = true,
	-- update the list when ECM updates it
	ConsoleExamineListUpdate = true,
	-- how wide the text for the history menu in the Console is
	ConsoleHistoryMenuLength = 50,
	-- the build/passibility grid in debug menu
	DebugGridOpacity = 15,
	DebugGridSize = 25,
	-- show offset grid numbers (0 == offset, 1 == actual hex grid)
	DebugGridPosition = 0,
	-- disabling this will still leave them for the cheats menu and cheats section
	EnableToolTips = true,
	-- append text or create a new file each dump
	ExamineAppendDump = true,
	-- view/dump text/object (true text, false object)
	ExamineTextType = true,
	-- coloured values in examine list
	ExamineColourNum = "255 255 0",
	ExamineColourBool = "0 255 0",
	ExamineColourBoolFalse = "255 150 150",
	ExamineColourStr = "255 255 255",
	ExamineColourNil = "175 175 175",
	-- what cmd/editor to use with os.execute(cmd) when doing external editing
	ExternalEditorCmd = [[notepad "%s"]],
	-- where to store temp file
	ExternalEditorPath = "AppData/EditorPlugin/",
	-- examine errors (useful when it contains a thread).
	ExamineErrors = false,
	ExamineObjectRadius = 2500,
	-- welcome msg
	FirstRun = true,
	-- just for you ski (prints a msg for each building removed)
	FixMissingModBuildingsLog = true,
	-- toggles vis of examined object a couple times on refresh/first examine
	FlashExamineObject = true,
	-- how wide the starting radius, how much to step per press
	FlattenGround_Radius = 2500,
	FlattenGround_HeightDiff = 100,
	FlattenGround_RadiusDiff = 100,
	-- dumps the log to disk on startup, and every new Sol (good for some crashes)
	FlushLog = false,
	-- call FlushLogFile() every render update
	FlushLogConstantly = false,
	-- every hour
	FlushLogHourly = false,
	-- show Cheats section in the selection panel
	InfopanelCheats = true,
	-- Add scrollbar to larger panel elements
	ScrollSelectionPanel = true,
	-- maybe you don't want to see the interface in screenshots
	ShowInterfaceInScreenshots = true,
	-- This savegame was loaded in the past without required mods or with an incompatible game version.
	SkipIncompatibleModsMsg = true,
	-- Mod Editor shows the help page every single time you open it.
	SkipModHelpPage = true,
	-- stops panel from shrinking
	StopSelectionPanelResize = true,
	-- remove any objects above the height limit (or game will delete save and crash).
	-- takes under a second to run, so best to enable by default
	RemoveHeightLimitObjs = true,
	-- change rollovers from 450 to 600
	WiderRollovers = 600,

	-- stores custom settings for each building
	BuildingSettings = {},
	-- resupply settings
	CargoSettings = {},
	-- transparent UI options stored here
	Transparency = {},
	-- stuff to show in Console>Examine list (tables/values/functions are fine)
	ConsoleExamineList = {
		"_G",
		"ChoGGi",
		"Consts",
		"DataInstances",
		"Dialogs",
		"EntityData",
		"g_Classes",
		"g_CObjectFuncs",
		"GlobalVars",
		"Mods",
		"Presets",
		"StoryBits",
		"ThreadsRegister",
		"UICity",
	},
	-- default off, but add entries to the settings file
	SkipMissingMods = false,
	SkipMissingDLC = false,
	MapEdgeLimit = false,
	ShowStartupTicks = false,
	FixMissingModBuildings = false,
}
-- my defaults
if testing then
	local Defaults = ChoGGi.Defaults
	-- add extra debugging defaults for me
	Defaults.ShowStartupTicks = true
--~ 	Defaults.WriteLogs = true
	Defaults.FixMissingModBuildings = true
	Defaults.FixMissingModBuildingsLog = false
	Defaults.ExamineErrors = true
	-- and maybe a bit of class
	Defaults.Transparency = {
		HUD = 50,
		PinsDlg = 50,
		XShortcutsHost = 100,
	}
	-- probably not useful for anyone who isn't loading up borked saves to test
	Defaults.SkipMissingMods = true
	Defaults.SkipMissingDLC = true
	-- camera lets you get closer to the edge
	Defaults.MapEdgeLimit = true
	-- the only good text editor
	Defaults.ExternalEditorCmd = [[scite "%s"]]
	-- dumps the log to disk on startup, and every new Sol (good for some crashes)
	Defaults.FlushLog = true
	-- ECM and Lib make a lot of these :)
	Defaults.ConsoleSkipUndefinedGlobals = true
	-- zoom out in asteroids
	Defaults.UnlockOverview = true
end

-- set game values to saved values
function ChoGGi.SettingFuncs.SetConstsToSaved()
	local UserSettings = ChoGGi.UserSettings
	local SetConstsG = ChoGGi.ComFuncs.SetConstsG
	local const = const

	local list = ChoGGi.Tables.Consts_names
	for i = 1, #list do
		local item = list[i]
		SetConstsG(item, UserSettings[item])
	end

	-- const.
	list = ChoGGi.Tables.const_names
	for i = 1, #list do
		local item = list[i]
		if UserSettings[item] then
			const[item] = UserSettings[item]
		end
	end

end

-- called everytime we set a setting in menu
function ChoGGi.SettingFuncs.WriteSettingsAdmin(settings)
	local ChoGGi = ChoGGi
	settings = settings or ChoGGi.UserSettings
	settings._SAVED = os.time()

	local bak = ChoGGi.settings_file .. ".bak"
	--locks the file while we write (i mean it says thread, ah well can't hurt)?
	ThreadLockKey(bak)
	AsyncCopyFile(ChoGGi.settings_file, bak)
	ThreadUnlockKey(bak)

	ThreadLockKey(ChoGGi.settings_file)
	table.sort(settings)
	-- and write it to disk
	local err = AsyncStringToFile(ChoGGi.settings_file, TableToLuaCode(settings))
	ThreadUnlockKey(ChoGGi.settings_file)

	if err then
		print(Strings[302535920000006--[[Failed to save settings to %s : %s]]]:format(
			ChoGGi.settings_file and ConvertToOSPath(ChoGGi.settings_file) or ChoGGi.settings_file,
			err
		))
		return false, err
	end
	return settings
end

-- read saved settings from file
function ChoGGi.SettingFuncs.ReadSettingsAdmin(settings)
	local ChoGGi = ChoGGi
	local err

	-- try to read settings
	if not settings then
		err, settings = AsyncFileToString(ChoGGi.settings_file)
		if err then
			-- no settings file so make a new one and read it
			ChoGGi.SettingFuncs.WriteSettings(ChoGGi.Defaults)
			err, settings = AsyncFileToString(ChoGGi.settings_file)
			-- something is definitely wrong so just abort, and let user know
			if err then
				PrintError(err)
				return
			end
		end
	end

	-- and convert it to lua / update in-game settings
	err, settings = LuaCodeToTuple(settings)
	if err then
		PrintError(err)
	end

	local UserSettings = ChoGGi.UserSettings
	-- update in-game settings, but keep the table the same for any locals I did
	for key, value in pairs(settings) do
		UserSettings[key] = value
	end

	if err or type(UserSettings) ~= "table" then
		-- so now at least the game will start
		settings = ChoGGi.Defaults
		for key, value in pairs(settings) do
			UserSettings[key] = value
		end
	end

	-- all is well (we return it for EditECMSettings)
	return settings
end

function ChoGGi.SettingFuncs.WriteSettingsLocal(settings)
	settings = settings or ChoGGi.UserSettings
	settings._SAVED = os.time()

	-- we want it stored as a table in LocalStorage, not a string (sometimes i send it as a string so)
	if type(settings) == "string" then
		local err
		err, settings = LuaCodeToTuple(settings)
		if err then
			return PrintError(err)
		end
	end

	LocalStorage.ModPersistentData[ChoGGi.id] = settings
	SaveLocalStorage()

	return settings
end

function ChoGGi.SettingFuncs.ReadSettingsLocal(settings)
	local ChoGGi = ChoGGi

	-- try to read settings
	if not settings then
		if LocalStorage.ModPersistentData[ChoGGi.id] then
			settings = LocalStorage.ModPersistentData[ChoGGi.id]
		end

		if not settings or not next(settings) then
			-- no settings so use defaults
			settings = ChoGGi.SettingFuncs.WriteSettingsLocal(ChoGGi.Defaults)
		end
	end

	local UserSettings = ChoGGi.UserSettings

	-- update in-game settings, but keep the table the same for any locals I did
	for key, value in pairs(settings) do
		UserSettings[key] = value
	end

	ChoGGi.UserSettings = settings

	if type(UserSettings) ~= "table" or not next(UserSettings) then
		-- so now at least the game will start
		settings = ChoGGi.Defaults

		for key, value in pairs(settings) do
			UserSettings[key] = value
		end
	end

	-- all is well (we return it for EditECMSettings)
	return settings
end

-- ClassesBuilt is the earliest we can call Consts funcs (which i don't actually call in here anymore...)
function OnMsg.ClassesBuilt()
	local UserSettings = ChoGGi.UserSettings
	-- If setting doesn't exist then add default
	local Defaults = ChoGGi.Defaults
	for key, value in pairs(Defaults) do
		if type(UserSettings[key]) == "nil" then
			UserSettings[key] = value
		end
	end

--~ 	for key, value in pairs(Defaults.XXXXXXX) do
--~ 		if type(UserSettings.XXXXXXX[key]) == "nil" then
--~ 			UserSettings.XXXXXXX[key] = value
--~ 		end
--~ 	end
end

local function RemoveEmpty(settings)
	for key, value in pairs(settings) do
		if not next(value) then
			settings[key] = nil
		end
	end
end
function OnMsg.ModsReloaded()
	RemoveEmpty(ChoGGi.UserSettings.BuildingSettings or empty_table)
	RemoveEmpty(ChoGGi.UserSettings.CargoSettings or empty_table)
end

-- we can local this now
local ChoGGi = ChoGGi

-- saving settings to a file or to local storage
if blacklist then
	-- check if settings are in AccountStorage and migrate them to LocalStorage
	local err, old_settings = ReadModPersistentData()
	if not err and old_settings and old_settings ~= "" then
		err, old_settings = AsyncDecompress(old_settings)
		if not err then
			err, old_settings = LuaCodeToTuple(old_settings)
			if not err then
				ChoGGi.UserSettings = old_settings
				-- bye-bye old settings
				WriteModPersistentData("")
			end
		end
	end

	-- where we store data in LocalStorage (i don't want to to have to check each time i save settings)
	if type(LocalStorage.ModPersistentData) ~= "table" then
		LocalStorage.ModPersistentData = {}
	end

	ChoGGi.SettingFuncs.ReadSettings = ChoGGi.SettingFuncs.ReadSettingsLocal
	ChoGGi.SettingFuncs.WriteSettings = ChoGGi.SettingFuncs.WriteSettingsLocal
else
	ChoGGi.SettingFuncs.ReadSettings = ChoGGi.SettingFuncs.ReadSettingsAdmin
	ChoGGi.SettingFuncs.WriteSettings = ChoGGi.SettingFuncs.WriteSettingsAdmin
end

-- and read our settings
ChoGGi.SettingFuncs.ReadSettings()

local UserSettings = ChoGGi.UserSettings

-- from here till the end of OnMsg.ChoGGi_Loaded()
if testing or UserSettings.ShowStartupTicks then
	ChoGGi.Temp.StartupTicks = GetPreciseTicks()
end

-- Menu>Consts settings saved here
if not UserSettings.Consts then
	UserSettings.Consts = {}
end

if UserSettings.ConsoleExamineListUpdate then
	UserSettings.ConsoleExamineList = ChoGGi.Defaults.ConsoleExamineList
end

-- bloody hint popups
if UserSettings.DisableHints then
	local mapdata = ActiveMapData
	if mapdata.DisableHints == false then
		mapdata.DisableHints = true
	end
	HintsEnabled = false
end

-- write logs to file (in-game instead of when quitting)
if not blacklist and UserSettings.WriteLogs then
	ChoGGi.ComFuncs.WriteLogs_Toggle(UserSettings.WriteLogs)
end
