-- See LICENSE for terms

-- stores default values and some tables

local next,pairs,type,table = next,pairs,type,table
local StringFormat = string.format
local LuaCodeToTuple = LuaCodeToTuple
local TableToLuaCode = TableToLuaCode
local SaveLocalStorage = SaveLocalStorage
local ThreadLockKey = ThreadLockKey
local ThreadUnlockKey = ThreadUnlockKey

function OnMsg.ClassesGenerate()
	-- used for loading/saving settings
	local function PrintError(err)
		local err_str = StringFormat("%s: %s",S[302535920000000--[[Expanded Cheat Menu--]]],S[302535920000243--[[Problem saving settings! Error: %s--]]]:format(err))
		if ChoGGi.Temp.GameLoaded then
			print(err_str)
		else
			ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = err_str
		end
	end

	--~ local Trans = ChoGGi.ComFuncs.Translate
	local S = ChoGGi.Strings
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
				ActionName = S[str_id],
				ActionId = name,
				ActionSortKey = sort,
				OnActionEffect = "popup",
				ChoGGi_ECM = true,
			}
		end
		AddMenuitem("ECM.Cheats",27,"01")
		AddMenuitem("ECM.Expanded CM",302535920000104,"02")
		AddMenuitem("ECM.Game",283142739680,"03")
		AddMenuitem("ECM.Debug",1000113,"04")
		AddMenuitem("ECM.Help",487939677892,"05")
	end -- do

	-- stores defaults
	ChoGGi.Defaults = {
		-- oh we'll change it
		_VERSION = 0,
		-- dark background for the console log
		ConsoleDim = true,
		-- shows a msg in the console log (maybe a popup would be better)
		FirstRun = true,
		-- default to opened (changed on click)
		InfopanelMainButVis = true,
		-- show Cheats pane in the selection panel
		InfopanelCheats = true,
		-- removes some useless crap from the Cheats pane (unless you're doing the tutorial then not as useless it seems)
		CleanupCheatsInfoPane = true,
		-- maybe you don't want to see the interface in screenshots
		ShowInterfaceInScreenshots = true,
		-- keep orientation of last placed building
		UseLastOrientation = true,
		-- show the cheats menu...
		ShowCheatsMenu = true,
		-- shows LUA ERRORs in console along with stack
		ConsoleErrors = true,
		-- update the list when ECM updates it
		ConsoleExamineListUpdate = true,
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
		-- disabling this will still leave them for the cheats menu and cheats pane
		EnableToolTips = true,
		-- append text or create new files
		ExamineAppendDump = true,
		-- how often we update when auto-refresh is turned on
		ExamineRefreshTime = 1000,
		-- what cmd/editor to use with os.execute(cmd) when doing external editing
		ExternalEditorCmd = "notepad \"%s\"",
		-- where to store temp file
		ExternalEditorPath = "AppData/EditorPlugin/",
		-- blinky blink
		FlashExamineObject = true,
		-- dumps the log to disk on startup, and every new Sol (good for some crashes)
		FlushLog = true,
		-- dumps log to disk every in-game hour (30 000 ticks of GameTime)
		FlushLogConstantly = false,
		-- okay, maybe some people don't want a mod to change the title of their game
		ChangeWindowTitle = true,
		-- how wide the starting radius, how much to step per press
		FlattenGround_Radius = 2500,
		FlattenGround_HeightDiff = 100,
		FlattenGround_RadiusDiff = 100,
		-- the build/passibility grid in debug menu
		DebugGridSize = 25,
		DebugGridOpacity = 15,
		-- how wide the text for the history menu in the Console is
		ConsoleHistoryMenuLength = 50,
		-- just for you ski (prints a msg for each building removed)
		FixMissingModBuildingsLog = true,
		-- Mod Editor shows the help page every single time you open it.
		SkipModHelpPage = true,
		-- stops panel from shrinking
		StopSelectionPanelResize = false,
		-- stores custom settings for each building
		BuildingSettings = {},
		-- resupply settings
		CargoSettings = {},
		-- transparent UI options stored here
		Transparency = {},
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
		ChoGGi.Defaults.StopSelectionPanelResize = true
		ChoGGi.Defaults.ExternalEditorCmd = "scite \"%s\""
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
--~ 			"DroneMeteorMalfunctionChance",
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
			"RCRoverDroneRechargeCost",
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

		local bak = StringFormat("%s.bak",ChoGGi.SettingsFile)
		--locks the file while we write (i mean it says thread, ah well can't hurt)?
		ThreadLockKey(bak)
		AsyncCopyFile(ChoGGi.SettingsFile,bak)
		ThreadUnlockKey(bak)

		ThreadLockKey(ChoGGi.SettingsFile)
		table.sort(settings)
		-- and write it to disk
		local err = AsyncStringToFile(ChoGGi.SettingsFile,TableToLuaCode(settings))
		ThreadUnlockKey(ChoGGi.SettingsFile)

		if err then
			print(S[302535920000006--[[Failed to save settings to %s : %s--]]]:format(
				ChoGGi.SettingsFile and ConvertToOSPath(ChoGGi.SettingsFile) or ChoGGi.SettingsFile,
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
			err, settings = AsyncFileToString(ChoGGi.SettingsFile)
			if err then
				-- no settings file so make a new one and read it
				ChoGGi.SettingFuncs.WriteSettingsOrig()
				err, settings = AsyncFileToString(ChoGGi.SettingsFile)
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

	-- ClassesBuilt is the earliest we can call Consts funcs
	function OnMsg.ClassesBuilt()
		local Defaults = ChoGGi.Defaults
		local UserSettings = ChoGGi.UserSettings

		-- if setting doesn't exist then add default
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

	do -- AddOldSettings
		-- used to add old lists to new combined list
		local function AddOldSettings(UserSettings,old_cat,new_name)
			local BuildingTemplates = BuildingTemplates
			-- then loop through it
			local old_cat = UserSettings[old_cat] or {}
			for key,value in pairs(old_cat) do
				--it likely doesn't exist, but check first and add a blank table
				if not UserSettings.BuildingSettings[key] then
					UserSettings.BuildingSettings[key] = {}
				end
				-- add it to vistors list?
				if new_name == "capacity" and BuildingTemplates[key].max_visitors then
					UserSettings.BuildingSettings[key].visitors = value
				else
					UserSettings.BuildingSettings[key][new_name] = value
				end
			end
			-- remove old settings
			UserSettings[old_cat] = nil
			return true
		end

		function OnMsg.ModsReloaded()
			local ChoGGi = ChoGGi
			local next = next

			-- remove empty entries in BuildingSettings
			local BuildingSettings = ChoGGi.UserSettings.BuildingSettings
			if next(BuildingSettings) then
				-- remove any empty building tables
				for key,_ in pairs(BuildingSettings) do
					if not next(BuildingSettings[key]) then
						BuildingSettings[key] = nil
					end
				end
			-- if empty table then new settings file or old settings
			else
				-- then we check if this is an older version still using the old way of storing building settings and convert over to new
				if not AddOldSettings(ChoGGi.UserSettings,"BuildingsCapacity","capacity") then
					ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = S[302535920000008--[[Error: Couldn't convert old settings to new settings: %s--]]]:format("BuildingsCapacity")
				end
				if not AddOldSettings(ChoGGi.UserSettings,"BuildingsProduction","production") then
					ChoGGi.Temp.StartupMsgs[#ChoGGi.Temp.StartupMsgs+1] = S[302535920000008--[[Error: Couldn't convert old settings to new settings: %s--]]]:format("BuildingsProduction")
				end
			end

			-- remove empty entries in CargoSettings
			local CargoSettings = ChoGGi.UserSettings.CargoSettings or {}
			for key,_ in pairs(CargoSettings) do
				if not next(CargoSettings[key]) then
					CargoSettings[key] = nil
				end
			end
		end
	end -- do

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

	-- could've been from when i used encyclopedia_id for this?
	if ChoGGi.UserSettings.BuildingSettings[""] then
		ChoGGi.UserSettings.BuildingSettings[""] = nil
	end

	if ChoGGi.UserSettings.ConsoleExamineListUpdate then
		ChoGGi.UserSettings.ConsoleExamineList = ChoGGi.Defaults.ConsoleExamineList
	end

	if ChoGGi.testing or ChoGGi.UserSettings.ShowStartupTicks then
		-- from here to the end of OnMsg.ChoGGi_Loaded()
		ChoGGi.Temp.StartupTicks = GetPreciseTicks()
	end

	-- bloody hint popups
	if ChoGGi.UserSettings.DisableHints then
		mapdata.DisableHints = true
		HintsEnabled = false
	end

	-- write logs to file (in-game instead of when quitting)
	if not blacklist and ChoGGi.UserSettings.WriteLogs then
		ChoGGi.ComFuncs.WriteLogs_Toggle(ChoGGi.UserSettings.WriteLogs)
	end

end
