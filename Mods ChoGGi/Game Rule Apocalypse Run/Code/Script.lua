-- See LICENSE for terms

local IsGameRuleActive = IsGameRuleActive

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

	if not MainCity or not IsGameRuleActive("ChoGGi_ApocalypseRun") then
		return
	end

	-- Always disable it
	g_Consts.OutsourceDisabled = 1

	if g_ChoGGi_ApocalypseRun_DisableResupply then
		g_Consts.SupplyMissionsEnabled = -1
	end

	-- Storybits
	local StoryBits = StoryBits
	for id in pairs(mod_options) do
		StoryBits[id].Enabled = mod_options[id]
	end

	-- Needed for asteroids
	if not MainCity and IsGameRuleActive("ChoGGi_ApocalypseRun") then
		g_Consts.SupplyMissionsEnabled = 1
	end
end
OnMsg.CityStart = UpdateLocks
OnMsg.LoadGame = UpdateLocks
-- Switch between different maps (can happen before UICity)
OnMsg.ChangeMapDone = UpdateLocks

-- Resupply lock
function OnMsg.PassengerRocketLaunched()
	if not IsGameRuleActive("ChoGGi_ApocalypseRun") then
		return
	end

	g_ChoGGi_ApocalypseRun_DisableResupply = true
	g_Consts.SupplyMissionsEnabled = -1
end
function OnMsg.NewDay(sol) -- NewSol...
	if not IsGameRuleActive("ChoGGi_ApocalypseRun") then
		return
	end

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
	if not IsGameRuleActive("ChoGGi_ApocalypseRun") then
		return ChoOrig_TrytoSpawnSpecialProject(poi, ...)
	end

	if poi and skip_poi[poi.id] then
		return
	end
	return ChoOrig_TrytoSpawnSpecialProject(poi, ...)
end

function OnMsg.ClassesPostprocess()
	if GameRulesMap.ChoGGi_ApocalypseRun then
		return
	end

	PlaceObj("GameRules", {
		challenge_mod = 173,
		description = T(0000, [[
Disable as much Earth related stuff as can be.

No Outsourcing or Resupply (resupply disables after 13 Sols or first passenger rocket launches, mod option to increase delay).
Disabled Expeditions:
High-speed Comm Satellite, Launch SETI Satellite, Contact Exploration Access.
Disabled Story bits (mod options to enable, can be done after start):
Applicants Profiling, Renegades: Evil Genius, Battle Royale, Black PR, Blank Slate, The Great Leap, Rapid Expansion, Mandatory Upgrades, Training Program, Research Cooperation, Diminishing Returns, The Martian Trail, Cold Machines, Cure For Cancer, Experimental Rocket, Splinters of Mars, Food Fight, Geological Treasure, Fickle Economics, Investment Opportunity, Jackpot, Live From Earth, Mars's Got Talent, Cydonia da Vinci, Multi-planetary Species, Mutual Interests, Refugee Crisis, Rocket Launch Failed, Survey Offer, The Door to Summer, The Fugitive, Mars or Bust!, Sanity Breakdown - Vagrancies of Fame, Water Chip


<grey>"Well, I'd certainly say she had marvelous judgment, Albert... if not particularly good taste."
<right>Blood</grey><left>]]),
		display_name = T(0000, "Apocalypse Run"),
		group = "Default",
		id = "ChoGGi_ApocalypseRun",
	})
end
