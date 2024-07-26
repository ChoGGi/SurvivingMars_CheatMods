-- See LICENSE for terms

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
	"EarthTrojan",
	"ExperimentalRocket",
	"ExportWasteRock_SplintersOfMars",
	"FoodFight",
	"GeologicalTreasure",
	"GravitationalWaves",
	"IncreaseResourceCost",
	"InvestmentOpportunity",
	"Jackpot",
	"LiveFromEarth",
	"MarsGotTalent",
	"Masterpiece",
	"MultiplanetSpecies",
	"MutualInterests",
	"NinthPlanet",
	"OortCloud",
	"RefugeeCrisis",
	"RocketLaunchFailed",
	"ShuttleTunnelRacing",
	"SuperHabitableWorld",
	"SurveyOffer",
	"TheDoorToSummer",
	"TheFugitive",
	"Tourism_MarsorBust",
	"VagranciesOfFame",
	"WaterChip",
}

local mod_options = {}
local c = 0

local table = table
local PlaceObj = PlaceObj
local T = T

local StoryBits = StoryBits
for i = 1, #bits do
	local id = bits[i]
	local item = StoryBits[id]
	c = c + 1
	mod_options[c] = PlaceObj("ModItemOptionToggle", {
		"name", id,
		"DisplayName", table.concat(T(0000, "<color 200 200 150>Storybit</color>: ") .. T(item.Title)),
		"Help", table.concat(T(id == "ExperimentalRocket" and item.VoicedText or item.Text) .. "\n\n<image " .. item.Image .. ">"),
		"DefaultValue", true,
	})
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

-- insert at top
table.insert(mod_options, 1, PlaceObj("ModItemOptionNumber", {
	"name", "ResupplyLockDelay",
	"DisplayName", T(0000, "Resupply Lock Delay"),
	"Help", T(0000, "How many Sols before resupply is locked down."),
	"DefaultValue", 13,
	"MinValue", 1,
	"MaxValue", 50,
}))

return mod_options
