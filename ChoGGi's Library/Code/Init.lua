local LICENSE = [[
Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) [2018] [ChoGGi]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

-- I should really split this into funcs and settings... one of these days
ChoGGi = {
	-- see above
	_LICENSE = LICENSE,
	-- ECM
	id = "ChoGGi_CheatMenu",
	-- constants
	Consts = {
		LightmodelCustom = {
			id = "ChoGGi_Custom",
			pp_bloom_strength = 100,
			pp_bloom_threshold = 25,
			pp_bloom_contrast = 75,
			pp_bloom_colorization = 65,
			pp_bloom_inner_tint = -4515950,
			pp_bloom_mip2_radius = 8,
			pp_bloom_mip3_radius = 10,
			pp_bloom_mip4_radius = 27,
			exposure = -100,
			gamma = -11776858,
		},

	-- const.* (I don't think these have default values in-game anywhere, so manually set them.) _GameConst.lua
		RCRoverMaxRadius = 20,
		CommandCenterMaxRadius = 35,
		BreakThroughTechsPerGame = 13,
		OmegaTelescopeBreakthroughsCount = 3,
		ExplorationQueueMaxSize = 10,
		fastGameSpeed = 5,
		mediumGameSpeed = 3,
		MoistureVaporatorPenaltyPercent = 40,
		MoistureVaporatorRange = 5,
		ResearchQueueSize = 4,
		ResourceScale = 1000,
		ResearchPointsScale = 1000,
		guim = 100,
		InvalidPos = InvalidPos(),
	-- Consts.* (Consts is a prop object, so we can get the defaults later on from OnMsg.OptionsApply(), we declare them now so we can loop them later) _const.lua
		AvoidWorkplaceSols = false,
		BirthThreshold = false,
		CargoCapacity = false,
		ColdWaveSanityDamage = false,
		CommandCenterMaxDrones = false,
		Concrete_cost_modifier = false,
		Concrete_dome_cost_modifier = false,
		CrimeEventDestroyedBuildingsCount = false,
		CrimeEventSabotageBuildingsCount = false,
		CropFailThreshold = false,
		DeepScanAvailable = false,
		DefaultOutsideWorkplacesRadius = false,
		DroneBuildingRepairAmount = false,
		DroneBuildingRepairBatteryUse = false,
		DroneCarryBatteryUse = false,
		DroneConstructAmount = false,
		DroneConstructBatteryUse = false,
		DroneDeconstructBatteryUse = false,
		DroneMoveBatteryUse = false,
		DroneRechargeTime = false,
		DroneRepairSupplyLeak = false,
		DroneResourceCarryAmount = false,
		DroneTransformWasteRockObstructorToStockpileAmount = false,
		DroneTransformWasteRockObstructorToStockpileBatteryUse = false,
		DustStormSanityDamage = false,
		Electronics_cost_modifier = false,
		Electronics_dome_cost_modifier = false,
		FoodPerRocketPassenger = false,
		HighStatLevel = false,
		HighStatMoraleEffect = false,
		InstantCables = false,
		InstantPipes = false,
		IsDeepMetalsExploitable = false,
		IsDeepPreciousMetalsExploitable = false,
		IsDeepWaterExploitable = false,
		LowSanityNegativeTraitChance = false,
		LowSanitySuicideChance = false,
		LowStatLevel = false,
		MachineParts_cost_modifier = false,
		MachineParts_dome_cost_modifier = false,
		MaxColonistsPerRocket = false,
		Metals_cost_modifier = false,
		Metals_dome_cost_modifier = false,
		MeteorHealthDamage = false,
		MeteorSanityDamage = false,
		MinComfortBirth = false,
		MysteryDreamSanityDamage = false,
		NoHomeComfort = false,
		NonSpecialistPerformancePenalty = false,
		OutsourceMaxOrderCount = false,
		OutsourceResearch = false,
		OutsourceResearchCost = false,
		OxygenMaxOutsideTime = false,
		PipesPillarSpacing = false,
		Polymers_cost_modifier = false,
		Polymers_dome_cost_modifier = false,
		positive_playground_chance = false,
		PreciousMetals_cost_modifier = false,
		PreciousMetals_dome_cost_modifier = false,
		ProjectMorphiousPositiveTraitChance = false,
		RCRoverDroneRechargeCost = false,
		RCRoverMaxDrones = false,
		RCRoverTransferResourceWorkTime = false,
		RCTransportGatherResourceWorkTime = false,
		rebuild_cost_modifier = false,
		RenegadeCreation = false,
		SeeDeadSanity = false,
		TimeBeforeStarving = false,
		TravelTimeEarthMars = false,
		TravelTimeMarsEarth = false,
		VisitFailPenalty = false,
	},
	-- default ECM settings
	Defaults = false,
	-- means of communication
	email = "SM_Mods@choggi.org",
	-- font used for various UI stuff
	font = "droid",
	-- Wha'choo talkin' 'bout, Willis?
	lang = GetLanguage(),
	-- path to this mods' folder
	LibraryPath = CurrentModPath,
	-- i translate all my strings at startup (and a couple of the built-in ones)
	Strings = false,
	-- easier access to some data (traits,cargo,mysteries,colonist data)
	Tables = false,
	-- stuff that isn't ready for release, more print msgs, and some default settings
	testing = false,
	--
	newline = Platform.pc and "\r\n" or "\n",

	-- CommonFunctions.lua
	ComFuncs = {
	-- thanks for replacing concat... what's wrong with using table.concat2?
		TableConcat = rawget(_G, "oldTableConcat") or table.concat,
		DebugGetInfo = format_value,
	},
	-- orig funcs that get replaced
	OrigFuncs = {},
	-- /Menus/*
	MenuFuncs = {},
	-- OnMsgs.lua
	MsgFuncs = {},
	-- InfoPaneCheats.lua
	InfoFuncs = {},
	-- Defaults.lua
	SettingFuncs = {},
	-- ConsoleFuncs.lua
	ConsoleFuncs = {},
	-- temporary... stuff
	Temp = {
		-- collect error msgs to be displayed in console after game is loaded
		StartupMsgs = {},
		-- a list of menuitems and shortcut keys for Msg("ShortcutsReloaded")
		Actions = {},
		-- Transparency for some of my dialogs (ex and console log)
		transp_mode = false,
		-- stores a table of my dialogs
		Dialogs = {},
	},
	-- settings that are saved to SettingsFile
	UserSettings = {
		BuildingSettings = {},
		Transparency = {},
	},
}
local ChoGGi = ChoGGi

do -- translate
	local locale_path = string.format("%sLocales/%s.csv",ChoGGi.LibraryPath,"%s")
	-- load locale translation (if any, not likely with the amount of text, but maybe a partial one)
	if not LoadTranslationTableFile(locale_path:format(GetLanguage())) then
		LoadTranslationTableFile(locale_path:format("English"))
	end

	Msg("TranslationChanged")
end

if Mods.ChoGGi_testing then
	ChoGGi.testing = {}
end

function printC(...)
	if ChoGGi.testing then
		print(...)
	end
end
