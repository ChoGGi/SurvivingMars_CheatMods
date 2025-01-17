-- See LICENSE for terms

local dlc_ids = {
	"AsteroidHopping",
	"BlueSunExportedAlot",
	"BlueSunProducedFunding",
	"BrazilConvertedWasteRock",
	"Built1000Buildings",
	"BuiltArtificialSun",
	"BuiltExcavator",
	"BuiltGeoscapeDome",
	"BuiltMoholeMine",
	"BuiltOmegaTelescope",
	"BuiltProjectMorpheus",
	"BuiltSeveralWonders",
	"BuiltSpaceElevator",
	"ChinaReachedHighPopulation",
	"ChinaTaiChiGardens",
	"ColonistWithRareTraits",
	"CompletedLandscapeProject",
	"CompletedMeltThePolarCapsSP",
	"CompletedMystery1",
	"CompletedMystery2",
	"CompletedMystery3",
	"CompletedMystery4",
	"CompletedMystery5",
	"CompletedMystery6",
	"CompletedOpenCity",
	"CuredColonists",
	"DeepScannedAllSectors",
	"EarthsickColonistStays",
	"EuropeResearchedAlot",
	"EuropeResearchedBreakthroughs",
	"FirstAnalyzedAnomaly",
	"FirstAndroid",
	"FirstBlueSky",
	"FirstChildBorn",
	"FirstDome",
	"FirstDomeSpire",
	"FirstHarvest",
	"FirstLiquidLake",
	"FirstNormalRain",
	"FirstRebornColonist",
	"FirstRefueledRocket",
	"FirstSeedsHarvest",
	"FirstShuttleHub",
	"FirstTreePlanted",
	"GatheredFunding",
	"Had100ColonistsInDome",
	"Had50AndroidsInDome",
	"HadColonistWith5Perks",
	"HadVegans",
	"IndiaBuiltDomes",
	"IndiaConvertedWasteRock",
	"IntotheUnknown",
	"JapanTrainedSpecialists",
	"JobDone",
	"Landed50Rockets",
	"LastFounderPassedColonyApproval",
	"MaxedAllTPs",
	"MaximumSatisfaction",
	"MissionSuccess",
	"Multitasking",
	"MysteriesofMars",
	"NewArcChurchMartianborns",
	"NewArkChurchHappyColonists",
	"NoMoreToxicRains",
	"PassedColonyApproval",
	"PerfectRun",
	"Reached1000Colonists",
	"Reached250Colonists",
	"ResearchedAllTechs",
	"RussiaExtractedAlot",
	"RussiaHadManyColonists",
	"ScannedAllSectors",
	"ShotDownAMeteorite",
	"SpaceDwarves",
	"SpaceExplorer",
	"SpaceYBuiltDrones",
	"SpaceYCompletedGoals",
	"USAGeoscapeDomeWithMegamall",
	"USAResearchedEngineering",
	"Willtheyhold",
}

local AchievementUnlock = AchievementUnlock
local EngineCanUnlockAchievement = EngineCanUnlockAchievement
local WaitMsg = WaitMsg
local XPlayerActive = XPlayerActive
local Sleep = Sleep
local AsyncRand = AsyncRand

local function UnlockAchievement(id, skip)
	if skip or EngineCanUnlockAchievement(XPlayerActive, id) then
		AchievementUnlock(XPlayerActive, id)
		Sleep(AsyncRand(250)+1)
	end
end

local mod_UnlockAllAchievements

local function StartupCode()
	CreateRealTimeThread(function()

		if mod_UnlockAllAchievements then
			for i = 1, #dlc_ids do
				-- Add a bit of random delay
				Sleep(AsyncRand(250)+1)
				UnlockAchievement(dlc_ids[i], true)
			end
		else
			local AchievementPresets = AchievementPresets
			for id in pairs(AchievementPresets) do
				Sleep(AsyncRand(250)+1)
				UnlockAchievement(id)
			end
		end

	end)
end

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_UnlockAllAchievements = CurrentModOptions:GetProperty("UnlockAllAchievements")

	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
