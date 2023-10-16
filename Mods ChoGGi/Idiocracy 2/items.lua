-- See LICENSE for terms

return {
	PlaceObj('ModItemDecalEntity', {
		'name', "IdiotDecal",
		'entity_name', "IdiotDecal",
		'filename', "UI/IdiotLogoUI.png",
	}),
	PlaceObj('ModItemMissionLogoPreset', {
		decal_entity = "IdiotDecal",
		entity_name = "IdiotDecal",
		display_name = T(610533935631, "Idiocracy"),
		id = "ChoGGi_Idiocracy2_Logo",
		image = "UI/IdiotLogoUI.png",
		group = "Default",
	}),
	PlaceObj('ModItemMissionSponsorPreset', {
		id = "ChoGGi_Idiocracy2_Sponsor",
		name = "ChoGGi_Idiocracy2_Sponsor",
		default_logo = "ChoGGi_Idiocracy2_Logo",
		initial_applicants = 206,
		initial_rockets = 1,
		challenge_mod = 201,
		display_name = T(610533935631, "Idiocracy"),
		effect = T(219160545510, [[Research per Sol: <research(0)>

- All colonists are <em>Idiots</em>
- No research technologies unlocked
- No sponsored research]]),
		game_apply = function(self)
			CreateGameTimeThread(function()
				Sleep(100) -- Wait until applicants generation has completed
				g_ApplicantPoolFilter.Idiot = nil
			end)
			-- Overwrite discovered (but not researched, possibly from the commander profile) techs to achieve the 'no techs unlocked' effect
			local statuses = UIColony.tech_status
			for _, status in pairs(statuses) do
				if status.discovered and not status.researched then
					status.discovered = false
				end
			end
		end,
		difficulty = T(0000, "Stupid"),
		funding = 10000,
		initial_techs_unlocked = 0,
		trait = "Idiot",
		PlaceObj('Effect_ModifyLabel', {
			Label = "Consts",
			Percent = -100,
			Prop = "SponsorResearch",
		}),
		group = "Default",
		sponsor_nation_name1 = "American",
		sponsor_nation_percent1 = 100,

--~ 		goal_1_param_1 = "6",
--~ 		goal_image_1 = "UI/Messages/Goals/mission_goal_06.tga",
--~ 		goal_pin_image_1 = "UI/Icons/Buildings/supply_pod.tga",
--~ 		reward_effect_1 = PlaceObj("RewardPrefab", {
--~ 			"Amount",
--~ 			3,
--~ 			"Prefab",
--~ 			"DomeDiamond"
--~ 		}),
--~ 		sponsor_goal_1 = "CompleteBreakthroughs",

--~ 		goal_2_param_1 = "400",
--~ 		goal_2_param_2 = "PreciousMetals",
--~ 		goal_image_2 = "UI/Messages/Goals/mission_goal_05.tga",
--~ 		goal_pin_image_2 = "UI/Icons/Buildings/funding.tga",
--~ 		reward_effect_2 = PlaceObj("RewardFunding", {"Amount", 3000000000}),
--~ 		sponsor_goal_2 = "ProduceUndergroundResource",

--~ 		goal_3_param_1 = "25",
--~ 		goal_3_param_2 = "85",
--~ 		goal_image_3 = "UI/Messages/Goals/mission_goal_06.tga",
--~ 		goal_pin_image_3 = "UI/Icons/Colonists/Malenone.tga",
--~ 		reward_effect_3 = PlaceObj("RewardApplicants", {
--~ 				"Amount",
--~ 				6,
--~ 				"Trait",
--~ 				"Saint"
--~ 			}),
--~ 		sponsor_goal_3 = "MartianbornTimed",

--~ 		goal_4_param_1 = "10",
--~ 		goal_image_4 = "UI/Messages/Goals/mission_goal_02.tga",
--~ 		goal_pin_image_4 = "UI/Icons/Colonists/Femaleengineer.tga",
--~ 		reward_effect_4 = PlaceObj("RewardApplicants", {
--~ 				"Amount",
--~ 				24,
--~ 				"Trait",
--~ 				"Workaholic",
--~ 				"Specialization",
--~ 				"engineer"
--~ 			}),
--~ 		sponsor_goal_4 = "AnalyzePlanetaryAnomalies",

--~ 		goal_5_param_1 = "4",
--~ 		goal_image_5 = "UI/Messages/Goals/mission_goal_09.tga",
--~ 		goal_pin_image_5 = "UI/Icons/Buildings/research.tga",
--~ 		reward_effect_5 = PlaceObj("RewardResearchPoints", {"Amount", 15000}),
--~ 		sponsor_goal_5 = "DomeSpires",

	}),

	PlaceObj("ModItemCommanderProfilePreset", {
		display_name = T(0000, "Pvt Bauers"),
		effect = T(0000, [[- Reduce chance of Idiots breaking things by 25%
- Increased water requirements for farm crops by 0.6
- Acts as <color em>Politician</color> for story bits]]),
		group = "Default",
		id = "ChoGGi_Idiocracy2_Commander",
	}),

}
