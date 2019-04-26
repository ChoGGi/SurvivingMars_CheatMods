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
	-- constants
	Consts = {
	-- const.* (I don't think these have default values in-game anywhere, so manually set them.) _GameConst.lua
		RCRoverMaxRadius = const.RCRoverMaxRadius or 20,
		CommandCenterMaxRadius = const.CommandCenterMaxRadius or 35,
		BreakThroughTechsPerGame = const.BreakThroughTechsPerGame or 13,
		OmegaTelescopeBreakthroughsCount = const.OmegaTelescopeBreakthroughsCount or 3,
		ExplorationQueueMaxSize = const.ExplorationQueueMaxSize or 10,
		fastGameSpeed = const.fastGameSpeed or 5,
		mediumGameSpeed = const.mediumGameSpeed or 3,
		MoistureVaporatorPenaltyPercent = const.MoistureVaporatorPenaltyPercent or 40,
		MoistureVaporatorRange = const.MoistureVaporatorRange or 5,
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
		ExportPricePreciousMetals = false,
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
		NonHomeDomePerformancePenalty = false,
		NonSpecialistPerformancePenalty = false,
		OutsideWorkplaceSanityDecrease = false,
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
		-- ECM will replace this with unblacklisted _G if ECM HelperMod is installed
		_G = _G,
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
end

-- fake mod used to tell if it's my comp, if you want some extra msgs and .testing funcs have at it
if Mods.ChoGGi_testing then
	ChoGGi.testing = {}
end

local testing = ChoGGi.testing
function printC(...)
	if testing then
		print(...)
	end
end
