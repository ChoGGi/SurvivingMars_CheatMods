-- See LICENSE for terms

-- stores default values and some tables

local next,pairs,type,table = next,pairs,type,table

local LuaCodeToTuple = LuaCodeToTuple
local TableToLuaCode = TableToLuaCode
local SaveLocalStorage = SaveLocalStorage
local ThreadLockKey = ThreadLockKey
local ThreadUnlockKey = ThreadUnlockKey

function OnMsg.ClassesGenerate()
	-- used for loading/saving settings
	local function PrintError(err)
		local err_str = Strings[302535920000000--[[Expanded Cheat Menu--]]] .. ": " .. Strings[302535920000243--[[Problem saving settings! Error: %s--]]]:format(err)
		if ChoGGi.Temp.GameLoaded then
			print(err_str)
		else
			ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = err_str
		end
	end

	local Translate = ChoGGi.ComFuncs.Translate
	local Strings = ChoGGi.Strings
	local blacklist = ChoGGi.blacklist

	local AsyncFileToString = not blacklist and AsyncFileToString
	local AsyncCopyFile = not blacklist and AsyncCopyFile
	local AsyncStringToFile = not blacklist and AsyncStringToFile

	do -- cheat menu custom menus
		local Actions = ChoGGi.Temp.Actions
		local c = #Actions
		local function AddMenuitem(name,str_id,sort)
			c = c + 1
			Actions[c] = {
				ActionMenubar = "DevMenu",
				ActionName = Translate(str_id),
				ActionId = name,
				ActionSortKey = sort,
				OnActionEffect = "popup",
				ChoGGi_ECM = true,
			}
		end
		AddMenuitem("ECM.Cheats",27,"01")
		AddMenuitem("ECM.ECM",302535920000887,"02")
		AddMenuitem("ECM.Game",283142739680,"03")
		AddMenuitem("ECM.Debug",1000113,"04")
		AddMenuitem("ECM.Help",487939677892,"05")
	end -- do

	-- stores defaults
	ChoGGi.Defaults = {
		-- oh we'll change it
		_VERSION = 0,
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
		-- disabling this will still leave them for the cheats menu and cheats section
		EnableToolTips = true,
		-- append text or create new files
		ExamineAppendDump = true,
		-- values in examine list
		ExamineColourNum = "255 255 0",
		ExamineColourBool = "0 255 0",
		ExamineColourBoolFalse = "255 150 150",
		ExamineColourStr = "255 255 255",
		ExamineColourNil = "175 175 175",
		-- what cmd/editor to use with os.execute(cmd) when doing external editing
		ExternalEditorCmd = "notepad \"%s\"",
		-- where to store temp file
		ExternalEditorPath = "AppData/EditorPlugin/",
		-- examine errors (useful when it contains a thread).
		ExamineErrors = false,
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
		FlushLog = true,
		-- dumps log to disk every in-game hour (30 000 ticks of GameTime)
		FlushLogConstantly = false,
		-- show Cheats section in the selection panel
		InfopanelCheats = true,
		-- toggle vis of the selection panel "main" buttons when you click the header (default to vis)
		InfopanelMainButVis = true,
		-- show the cheats menu...
		ShowCheatsMenu = true,
		-- maybe you don't want to see the interface in screenshots
		ShowInterfaceInScreenshots = true,
		-- Mod Editor shows the help page every single time you open it.
		SkipModHelpPage = true,
		-- stops panel from shrinking
		StopSelectionPanelResize = false,
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
			"Dialogs",
			"DataInstances",
			"EntityData",
			"g_Classes",
			"g_CObjectFuncs",
			"GlobalVars",
			"Presets",
			"StoryBits",
			"ThreadsRegister",
			"UICity",
		},
	}
	-- my defaults
	if ChoGGi.testing then
		local ChoGGi = ChoGGi
		-- add extra debugging defaults for me
		ChoGGi.Defaults.ShowStartupTicks = true
		ChoGGi.Defaults.WriteLogs = true
		ChoGGi.Defaults.FixMissingModBuildings = true
		-- and maybe a bit of class
		ChoGGi.Defaults.Transparency = {
			HUD = 50,
			PinsDlg = 50,
			XShortcutsHost = 100,
		}
		-- probably not useful for anyone who isn't loading up borked saves to test
		ChoGGi.Defaults.SkipMissingMods = true
		ChoGGi.Defaults.SkipMissingDLC = true
		--
		ChoGGi.Defaults.MapEdgeLimit = true
		ChoGGi.Defaults.StopSelectionPanelResize = true
		ChoGGi.Defaults.ExternalEditorCmd = "scite \"%s\""
		ChoGGi.Defaults.ExamineErrors = true
	end

	-- set game values to saved values
	function ChoGGi.SettingFuncs.SetConstsToSaved()
		local UserSettings = ChoGGi.UserSettings
--Consts.
		local list = {
			"AvoidWorkplaceSols",
			"BirthThreshold",
			"CargoCapacity",
			"ColdWaveSanityDamage",
			"CommandCenterMaxDrones",
			"Concrete_cost_modifier",
			"Concrete_dome_cost_modifier",
			"CrimeEventDestroyedBuildingsCount",
			"CrimeEventSabotageBuildingsCount ",
			"CropFailThreshold",
			"DeepScanAvailable",
			"DefaultOutsideWorkplacesRadius",
			"DroneBuildingRepairAmount",
			"DroneBuildingRepairBatteryUse",
			"DroneCarryBatteryUse",
			"DroneConstructAmount",
			"DroneConstructBatteryUse",
			"DroneDeconstructBatteryUse",
			"DroneMoveBatteryUse",
			"DroneRechargeTime",
			"DroneRepairSupplyLeak",
			"DroneResourceCarryAmount",
			"DroneTransformWasteRockObstructorToStockpileAmount",
			"DroneTransformWasteRockObstructorToStockpileBatteryUse",
			"DustStormSanityDamage",
			"Electronics_cost_modifier",
			"Electronics_dome_cost_modifier",
			"FoodPerRocketPassenger",
			"HighStatLevel",
			"HighStatMoraleEffect",
			"InstantCables",
			"InstantPipes",
			"IsDeepMetalsExploitable",
			"IsDeepPreciousMetalsExploitable",
			"IsDeepWaterExploitable",
			"LowSanityNegativeTraitChance",
			"LowSanitySuicideChance",
			"LowStatLevel",
			"MachineParts_cost_modifier",
			"MachineParts_dome_cost_modifier",
			"MaxColonistsPerRocket",
			"Metals_cost_modifier",
			"Metals_dome_cost_modifier",
			"MeteorHealthDamage",
			"MeteorSanityDamage",
			"MinComfortBirth",
			"MysteryDreamSanityDamage",
			"NoHomeComfort",
			"NonHomeDomePerformancePenalty",
			"NonSpecialistPerformancePenalty",
			"OutsourceMaxOrderCount",
			"OutsourceResearch",
			"OutsourceResearchCost",
			"OxygenMaxOutsideTime",
			"PipesPillarSpacing",
			"Polymers_cost_modifier",
			"Polymers_dome_cost_modifier",
			"positive_playground_chance",
			"PreciousMetals_cost_modifier",
			"PreciousMetals_dome_cost_modifier",
			"ProjectMorphiousPositiveTraitChance",
			"RCRoverMaxDrones",
			"RCRoverTransferResourceWorkTime",
			"RCTransportGatherResourceWorkTime",
			"rebuild_cost_modifier",
			"RenegadeCreation",
			"SeeDeadSanity",
			"TimeBeforeStarving",
			"TravelTimeEarthMars",
			"TravelTimeMarsEarth",
			"VisitFailPenalty",
		}
		local SetConstsG = ChoGGi.ComFuncs.SetConstsG
		for i = 1, #list do
			SetConstsG(list[i],UserSettings[list[i]])
		end
--const.
		list = {
			"BreakThroughTechsPerGame",
			"ExplorationQueueMaxSize",
			"fastGameSpeed",
			"mediumGameSpeed",
			"MoistureVaporatorPenaltyPercent",
			"MoistureVaporatorRange",
			"ResearchQueueSize",
			"RCRoverMaxRadius",
			"CommandCenterMaxRadius",
			"OmegaTelescopeBreakthroughsCount",
		}
		local const = const
		for i = 1, #list do
			if UserSettings[list[i]] then
				const[list[i]] = UserSettings[list[i]]
			end
		end
	end

	-- called everytime we set a setting in menu
	function ChoGGi.SettingFuncs.WriteSettingsAdmin(settings)
		local ChoGGi = ChoGGi
		settings = settings or ChoGGi.UserSettings

		local bak = ChoGGi.settings_file .. ".bak"
		--locks the file while we write (i mean it says thread, ah well can't hurt)?
		ThreadLockKey(bak)
		AsyncCopyFile(ChoGGi.settings_file,bak)
		ThreadUnlockKey(bak)

		ThreadLockKey(ChoGGi.settings_file)
		table.sort(settings)
		-- and write it to disk
		local err = AsyncStringToFile(ChoGGi.settings_file,TableToLuaCode(settings))
		ThreadUnlockKey(ChoGGi.settings_file)

		if err then
			print(Strings[302535920000006--[[Failed to save settings to %s : %s--]]]:format(
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
				ChoGGi.SettingFuncs.WriteSettingsOrig()
				err, settings = AsyncFileToString(ChoGGi.settings_file)
				-- something is definitely wrong so just abort, and let user know
				if err then
					PrintError(err)
				end
			end
		end

		-- and convert it to lua / update in-game settings
		err, ChoGGi.UserSettings = LuaCodeToTuple(settings)
		if err then
			PrintError(err)
		end

		if err or type(ChoGGi.UserSettings) ~= "table" then
			-- so now at least the game will start
			ChoGGi.UserSettings = ChoGGi.Defaults
			return ChoGGi.Defaults
		end

		-- all is well
		return settings

	end

	function ChoGGi.SettingFuncs.WriteSettingsLocal(settings)
		settings = settings or ChoGGi.UserSettings

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

			local LocalStorage = LocalStorage
			if LocalStorage.ModPersistentData[ChoGGi.id] then
				settings = LocalStorage.ModPersistentData[ChoGGi.id]
			end

			if not settings or not next(settings) then
				-- no settings so use defaults
				settings = ChoGGi.SettingFuncs.WriteSettingsLocal(ChoGGi.Defaults)
			end
		end

		-- update in-game settings
		ChoGGi.UserSettings = settings

		if type(ChoGGi.UserSettings) ~= "table" or not next(ChoGGi.UserSettings) then
			-- so now at least the game will start
			settings = ChoGGi.Defaults
			ChoGGi.UserSettings = settings
		end

		-- all is well (we return it for EditECMSettings)
		return settings

	end

--~ 	-- used to add old lists to new combined list
--~ 	function ChoGGi.SettingFuncs.AddOldSettings(settings,old_cat,new_name)
--~ 		local BuildingTemplates = BuildingTemplates
--~ 		-- then loop through it
--~ 		local old_cat = settings[old_cat] or empty_table
--~ 		for key,value in pairs(old_cat) do
--~ 			-- it likely doesn't exist, but check first and add a blank table
--~ 			if not settings.BuildingSettings[key] then
--~ 				settings.BuildingSettings[key] = {}
--~ 			end
--~ 			-- add it to vistors list?
--~ 			if new_name == "capacity" and BuildingTemplates[key].max_visitors then
--~ 				settings.BuildingSettings[key].visitors = value
--~ 			else
--~ 				settings.BuildingSettings[key][new_name] = value
--~ 			end
--~ 		end
--~ 		-- remove old settings
--~ 		settings[old_cat] = nil
--~ 		return true
--~ 	end

	-- we can local this now
	local ChoGGi = ChoGGi

	-- saving settings to a file or to local storage
	if blacklist then
		-- check if settings are in AccountStorage and migrate them to LocalStorage
		local err,old_settings = ReadModPersistentData()
		if not err and old_settings and old_settings ~= "" then
			err,old_settings = AsyncDecompress(old_settings)
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

	-- could've been from when i used encyclopedia_id for this?
	if UserSettings.BuildingSettings[""] then
		UserSettings.BuildingSettings[""] = nil
	end

	if UserSettings.ConsoleExamineListUpdate then
		UserSettings.ConsoleExamineList = ChoGGi.Defaults.ConsoleExamineList
	end

	if ChoGGi.testing or UserSettings.ShowStartupTicks then
		-- from here to the end of OnMsg.ChoGGi_Loaded()
		ChoGGi.Temp.StartupTicks = GetPreciseTicks()
	end

	-- bloody hint popups
	if UserSettings.DisableHints then
		mapdata.DisableHints = true
		HintsEnabled = false
	end

	-- write logs to file (in-game instead of when quitting)
	if not blacklist and UserSettings.WriteLogs then
		ChoGGi.ComFuncs.WriteLogs_Toggle(UserSettings.WriteLogs)
	end

	-- remove it once n fer all (brain fart from ShowScanAndMapOptions)
	UserSettings.DeepScanAvailable = nil
end

-- ClassesBuilt is the earliest we can call Consts funcs (which i don't actually call in here anymore...)
function OnMsg.ClassesBuilt()
	local UserSettings = ChoGGi.UserSettings
	-- if setting doesn't exist then add default
	local Defaults = ChoGGi.Defaults
	for key,value in pairs(Defaults) do
		if type(UserSettings[key]) == "nil" then
			UserSettings[key] = value
		end
	end

--~ 	for key,value in pairs(Defaults.XXXXXXX) do
--~ 		if type(UserSettings.XXXXXXX[key]) == "nil" then
--~ 			UserSettings.XXXXXXX[key] = value
--~ 		end
--~ 	end
end

function OnMsg.ModsReloaded()
	local ChoGGi = ChoGGi
	local next = next

	-- remove empty entries in BuildingSettings
	local BuildingSettings = ChoGGi.UserSettings.BuildingSettings
	if next(BuildingSettings) then
		-- remove any empty building tables
		for key,value in pairs(BuildingSettings) do
			if not next(value) then
				BuildingSettings[key] = nil
			end
		end
--~ 	-- if empty table then new settings file or old settings
--~ 	else

--~ 		-- i could probably stand to remove this now...

--~ 		-- then we check if this is an older version still using the old way of storing building settings and convert over to new
--~ 		if not ChoGGi.SettingFuncs.AddOldSettings(ChoGGi.UserSettings,"BuildingsCapacity","capacity") then
--~ 			ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = Strings[302535920000008--[[Error: Couldn't convert old settings to new settings: %s--]]]:format("BuildingsCapacity")
--~ 		end
--~ 		if not ChoGGi.SettingFuncs.AddOldSettings(ChoGGi.UserSettings,"BuildingsProduction","production") then
--~ 			ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = Strings[302535920000008--[[Error: Couldn't convert old settings to new settings: %s--]]]:format("BuildingsProduction")
--~ 		end

	end

	-- remove empty entries in CargoSettings
	local CargoSettings = ChoGGi.UserSettings.CargoSettings or {}
	for key,value in pairs(CargoSettings) do
		if not next(value) then
			CargoSettings[key] = nil
		end
	end
end
