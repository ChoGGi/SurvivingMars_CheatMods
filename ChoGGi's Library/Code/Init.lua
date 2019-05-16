-- See LICENSE for terms

local LICENSE = [[
Any code from https://github.com/HaemimontGames/SurvivingMars is copyright by their LICENSE

All of my code is licensed under the MIT License as follows:

MIT License

Copyright (c) [2019] [ChoGGi]

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
	-- anyone examining ChoGGi will see this first
	_LICENSE = LICENSE,
	-- ECM
	id = "ChoGGi_CheatMenu",
	-- this
	id_lib = "ChoGGi_Library",
	-- is ECM shanghaied by the blacklist?
	blacklist = true,
	-- constants
	Consts = {},
	-- default ECM settings
	Defaults = false,
	-- means of communication
	email = "SM_Mods@choggi.org",
	-- font used for various UI stuff
	font = "droid",
	-- Wha'choo talkin' 'bout, Willis?
	lang = GetLanguage(),
	-- path to this mods' folder
	library_path = CurrentModPath,
	-- stores my strings, and edited sm ones
	Strings = {},
	-- easier access to some data
	Tables = {
		Cargo = {},
		CargoPresets = {},
		ColonistAges = {},
		ColonistBirthplaces = {},
		ColonistGenders = {},
		ColonistSpecializations = {},
		Mystery = {},
		NegativeTraits = {},
		OtherTraits = {},
		PositiveTraits = {},
		Resources = {},
		SchoolTraits = {},
		SanatoriumTraits = {},
		-- don't want to have to declare these more than i have to
		Consts_names = {
			"AvoidWorkplaceSols",
			"BirthThreshold",
			"CargoCapacity",
			"ColdWaveSanityDamage",
			"CommandCenterMaxDrones",
			"Concrete_cost_modifier",
			"Concrete_dome_cost_modifier",
			"CrimeEventDestroyedBuildingsCount",
			"CrimeEventSabotageBuildingsCount",
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
			"DroneTimeToWorkOnLandscapeMultiplier",
			"DroneTransformWasteRockObstructorToStockpileAmount",
			"DroneTransformWasteRockObstructorToStockpileBatteryUse",
			"DustStormSanityDamage",
			"Electronics_cost_modifier",
			"Electronics_dome_cost_modifier",
			"ExportPricePreciousMetals",
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
			"OutsideWorkplaceSanityDecrease",
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
		},
		const_names = {
			"BreakThroughTechsPerGame",
			"CommandCenterMaxRadius",
			"DroneRestrictRadius",
			"ExplorationQueueMaxSize",
			"fastGameSpeed",
			"MaxToxicRainPools",
			"mediumGameSpeed",
			"MoistureVaporatorPenaltyPercent",
			"MoistureVaporatorRange",
			"OmegaTelescopeBreakthroughsCount",
			"RCRoverMaxRadius",
			"ResearchQueueSize",
		},
	},
	-- stuff that isn't ready for release, more print msgs, and some default settings
	testing = false,
	-- for text dumping (yep .pc means windows desktop, i guess .linux/.osx aren't personal computers)
	newline = Platform.pc and "\r\n" or "\n",
	-- CommonFunctions.lua/ECM_Functions.lua
	ComFuncs = {
		-- thanks for replacing concat... what's wrong with using table.concat2?
		TableConcat = rawget(_G, "oldTableConcat") or table.concat,
		DebugGetInfo = format_value,
	},
	-- orig funcs that get replaced
	OrigFuncs = {},
	-- /Menus/*
	MenuFuncs = {},
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
		-- rememeber transparency for some of my dialogs (ex and console log)
		transp_mode = false,
		-- stores a table of my dialogs
		Dialogs = {},
		-- they changed it once, they can change it again (trans func returns this for fail)
		missing_text = "Missing text",
	},
	-- settings that are saved to settings_file
	UserSettings = {
		BuildingSettings = {},
		Transparency = {},
		-- saved Consts settings
		Consts = {},
	},
}

do -- translate
	local locale_path = ChoGGi.library_path .. "Locales/"
	-- load locale translation (if any, not likely with the amount of text, but maybe a partial one)
	if not LoadTranslationTableFile(locale_path .. ChoGGi.lang .. ".csv") then
		LoadTranslationTableFile(locale_path .. "English.csv")
	end

	Msg("TranslationChanged")
end -- do

-- fake mod used to tell if it's my comp, if you want some extra msgs and .testing funcs have at it
if Mods.ChoGGi_testing then
	ChoGGi.testing = {}
	function printC(...)
		print(...)
	end
else
	printC = empty_func
end

do -- Add default Consts/const values to ChoGGi.Consts
	-- Consts.* (Consts is a prop object, so we can get the defaults later on from OnMsg.OptionsApply(), we declare them now so we can loop them later) _const.lua
	local cConsts = ChoGGi.Consts
	local Consts_names = ChoGGi.Tables.Consts_names
	for i = 1, #Consts_names do
		cConsts[Consts_names[i]] = false
	end

	-- const.* (I don't think these have default values in-game anywhere, so manually set them.) _GameConst.lua
	cConsts.RCRoverMaxRadius = const.RCRoverMaxRadius or 20
	cConsts.CommandCenterMaxRadius = const.CommandCenterMaxRadius or 35
--~ 	cConsts.DroneRestrictRadius = const.DroneRestrictRadius or 70000
	cConsts.BreakThroughTechsPerGame = const.BreakThroughTechsPerGame or 13
	cConsts.OmegaTelescopeBreakthroughsCount = const.OmegaTelescopeBreakthroughsCount or 3
	cConsts.ExplorationQueueMaxSize = const.ExplorationQueueMaxSize or 10
	cConsts.fastGameSpeed = const.fastGameSpeed or 5
	cConsts.MaxToxicRainPools = const.MaxToxicRainPools or 30
	cConsts.mediumGameSpeed = const.mediumGameSpeed or 3
	cConsts.MoistureVaporatorPenaltyPercent = const.MoistureVaporatorPenaltyPercent or 40
	cConsts.MoistureVaporatorRange = const.MoistureVaporatorRange or 5
	cConsts.InvalidPos = InvalidPos()
end -- do
