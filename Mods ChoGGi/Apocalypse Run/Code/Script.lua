-- See LICENSE for terms

GlobalVar("g_ChoGGi_ApocalypseRun_DisableResupply", false)

local bits = {
	"ApplicantProfiling",
	"BadBoyGenius",
	"BattleRoyale",
	"BlackPR",
	"BlankSlate",
	"Boost10_Frogleap",
	"Boost13_RapidExpansion",
	"Boost14_MandatoryUpgrades",
	"Boost16_TrainingProgram",
	"Boost18_ResearchCooperation",
	"Boost7_DiminishingReturns",
	"Boost8_TheMartianTrail",
	"ColdMachines",
	"Cure4Cancer",
	"ExperimentalRocket",
	"ExportWasteRock_SplintersOfMars",
	"FoodFight",
	"GeologicalTreasure",
	"IncreaseResourceCost",
	"InvestmentOpportunity",
	"Jackpot",
	"LiveFromEarth",
	"MarsGotTalent",
	"Masterpiece",
	"MultiplanetSpecies",
	"MutualInterests",
	"RefugeeCrisis",
	"RocketLaunchFailed",
	"SurveyOffer",
	"TheDoorToSummer",
	"TheFugitive",
	"Tourism_MarsorBust",
	"VagranciesOfFame",
	"WaterChip",
}
local mod_options = {}
for i = 1, #bits do
	mod_options[bits[i]] = false
end

local mod_ResupplyLockDelay

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	for id in pairs(mod_options) do
		mod_options[id] = options:GetProperty(id)
	end

	mod_ResupplyLockDelay = CurrentModOptions:GetProperty("ResupplyLockDelay")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function UpdateLocks()
	if not UICity then
		return
	end

	-- always disable it
	g_Consts.OutsourceDisabled = 1

	if g_ChoGGi_ApocalypseRun_DisableResupply then
		g_Consts.SupplyMissionsEnabled = -1
	end

	-- storybits
	local StoryBits = StoryBits
	for id in pairs(mod_options) do
		StoryBits[id].Enabled = mod_options[id]
	end
end
OnMsg.CityStart = UpdateLocks
OnMsg.LoadGame = UpdateLocks
-- switch between different maps (can happen before UICity)
OnMsg.ChangeMapDone = UpdateLocks

-- resupply lock
function OnMsg.PassengerRocketLaunched()
	g_ChoGGi_ApocalypseRun_DisableResupply = true
	g_Consts.SupplyMissionsEnabled = -1
end
function OnMsg.NewDay(sol) -- NewSol...
	if sol >= mod_ResupplyLockDelay then
		g_ChoGGi_ApocalypseRun_DisableResupply = true
		g_Consts.SupplyMissionsEnabled = -1
	end
end

-- g_SpecialProjectsDisabled can get reset on newday
local skip_poi = {
	HeighSpeedComSatellite = true,
	SETISatellite = true,
	StoryBit_ContractExplorationAccess = true,
}
local ChoOrig_TrytoSpawnSpecialProject = TrytoSpawnSpecialProject
function TrytoSpawnSpecialProject(poi, ...)
	if poi and skip_poi[poi.id] then
		return
	end
	return ChoOrig_TrytoSpawnSpecialProject(poi, ...)
end
