-- See LICENSE for terms

return {
	PlaceObj("ModItemMissionSponsorPreset", {
		id = "ChoGGi_CanadianSpaceAgency",
		name = "ChoGGi_CanadianSpaceAgency",
		group = "Default",
		comment = "We're go'in to Mars eh?",

		RCRover = 1,
		RCTransport = 1,
		DroneHub = 2,
		FuelFactory = 1,
		OrbitalProbe = 3,
		Electronics = 10,
		MachineParts = 15,
		Polymers = 15,
		MoistureVaporator = 1,

		default_skin = "Star",
		rocket_price = 2000000000,
		applicants_per_breakthrough = 3,
		cargo = 64000,
		challenge_mod = 200,
		colony_color_scheme = "red_steel",
		default_logo = "CSAlogo",

		display_name = T(300715699908, "Canadian Space Agency"),
		effect = T(182713539151, [[Research per Sol: 100
	Rare Metals price: $<ExportPricePreciousMetals> M
	Starting Applicants: <ApplicantsPoolStartingSize>

	- Gain 100M in Funding every time a tech is researched. Gain double if it's a Breakthrough tech. The Canadian government will not allow tech Outsourcing though.
	Canadian Rockets:
	- Slow, taking twice as long to make the trip to Mars.
	- Slightly larger cargo capacity due to logistical genius.
	- Only holds 10 colonists due to government safety regulations.
	Mining:
	- Deep Scanning is available at start.
	- Slightly more can be extracted from mines.
	]]),
		flavor = T(311546194702, [[

	Canada and space are a natural fit.
				Marc Garneau]]),
		funding = 3500,
		funding_per_breakthrough = 200,
		funding_per_tech = 125,
		initial_rockets = 1,
		initial_techs_unlocked = 1,
		pod_class = "SupplyPod",
		game_apply = function()
			GrantTech("DeepScanning")
		end,

		goal_1_param_1 = "6",
		goal_image_1 = "UI/Messages/Goals/mission_goal_06.tga",
		goal_pin_image_1 = "UI/Icons/Buildings/supply_pod.tga",
		reward_effect_1 = PlaceObj("RewardPrefab", {
			"Amount",
			3,
			"Prefab",
			"DomeDiamond"
		}),
		sponsor_goal_1 = "CompleteBreakthroughs",

		goal_2_param_1 = "400",
		goal_2_param_2 = "PreciousMetals",
		goal_image_2 = "UI/Messages/Goals/mission_goal_05.tga",
		goal_pin_image_2 = "UI/Icons/Buildings/funding.tga",
		reward_effect_2 = PlaceObj("RewardFunding", {"Amount", 3000000000}),
		sponsor_goal_2 = "ProduceUndergroundResource",

		goal_3_param_1 = "25",
		goal_3_param_2 = "85",
		goal_image_3 = "UI/Messages/Goals/mission_goal_06.tga",
		goal_pin_image_3 = "UI/Icons/Colonists/Malenone.tga",
		reward_effect_3 = PlaceObj("RewardApplicants", {
				"Amount",
				6,
				"Trait",
				"Saint"
			}),
		sponsor_goal_3 = "MartianbornTimed",

		goal_4_param_1 = "10",
		goal_image_4 = "UI/Messages/Goals/mission_goal_02.tga",
		goal_pin_image_4 = "UI/Icons/Colonists/Femaleengineer.tga",
		reward_effect_4 = PlaceObj("RewardApplicants", {
				"Amount",
				24,
				"Trait",
				"Workaholic",
				"Specialization",
				"engineer"
			}),
		sponsor_goal_4 = "AnalyzePlanetaryAnomalies",

		goal_5_param_1 = "4",
		goal_image_5 = "UI/Messages/Goals/mission_goal_09.tga",
		goal_pin_image_5 = "UI/Icons/Buildings/research.tga",
		reward_effect_5 = PlaceObj("RewardResearchPoints", {"Amount", 15000}),
		sponsor_goal_5 = "DomeSpires",

		sponsor_nation_name1 = "American",
		sponsor_nation_percent1 = 30,
		sponsor_nation_name2 = "French",
		sponsor_nation_percent2 = 20,
		sponsor_nation_name3 = "Japanese",
		sponsor_nation_percent3 = 5,
		sponsor_nation_name4 = "Indian",
		sponsor_nation_percent4 = 5,
		sponsor_nation_name5 = "Chinese",
		sponsor_nation_percent5 = 5,
		sponsor_nation_name6 = "English",
		sponsor_nation_percent6 = 30,
		sponsor_nation_name7 = "German",
		sponsor_nation_percent7 = 5,

		PlaceObj("Effect_ModifyLabel", {
			Amount = -40,
			Label = "Consts",
			Prop = "ApplicantsPoolStartingSize",
		}),
		PlaceObj("Effect_ModifyLabel", {
			Amount = -2,
			Label = "Consts",
			Prop = "MaxColonistsPerRocket",
		}),
		PlaceObj("Effect_ModifyLabel", {
			Amount = 100,
			Label = "AllRockets",
			Prop = "travel_time",
		}),
		PlaceObj("Effect_ModifyLabel", {
			Amount = 1,
			Label = "Consts",
			Prop = "OutsourceDisabled",
		}),
	}),


	PlaceObj("ModItemDecalEntity", {
		"name", "Canadian_Space_Agency_logo_2",
		"comment", "Decal for Canadian Space Agency 2",
		"entity_name", "Canadian_Space_Agency_logo_2",
		"display_name", "Canadian Space Agency 2",
	}),
	PlaceObj("ModItemMissionLogoPreset", {
		display_name = T(302535920011989, "Canadian Space Agency logo 2"),
		entity_name = "Canadian_Space_Agency_logo_2",
		decal_entity = "Canadian_Space_Agency_logo_2",
		id = "CSAlogo",
		image = "UI/Canadian_Space_Agency_logo_2.png",
		group = "Default",
	}),
	PlaceObj("ModItemDecalEntity", {
		"name", "Canadian_Space_Agency_logo_1",
		"comment", "Decal for Canadian Space Agency 1",
		"entity_name", "Canadian_Space_Agency_logo_1",
		"display_name", "Canadian Space Agency 1",
	}),
	PlaceObj("ModItemMissionLogoPreset", {
		display_name = T(234596496631, "Canadian Space Agency logo 1"),
		entity_name = "Canadian_Space_Agency_logo_1",
		decal_entity = "Canadian_Space_Agency_logo_1",
		id = "CSAlogo2",
		image = "UI/Canadian_Space_Agency_logo_1.png",
		group = "Default",
	}),


	PlaceObj("ModItemCommanderProfilePreset", {
--~ 		challenge_mod = 10,
		display_name = T(302535920011990, "Diplomat"),
		effect = T(302535920011991, [[- Reduce chance of Renegades by 20% (inc. Rebel Yell)
- Additional starting standing with rival colonies (trade tech from start)
- Bonus tech: Supportive community (colonists are less likely to gain flaws after sanity breakdown)
- Acts as <color em>Politician</color> for story bits]]),
		group = "Default",
		id = "ChoGGi_CanadianSpaceAgency_Commander",
		PlaceObj("Effect_ModifyLabel", {
			Label = "Consts",
			Percent = 20,
			Prop = "GameRuleRebelYellRenegadeCreation",
		}),
		PlaceObj("Effect_ModifyLabel", {
			Label = "Consts",
			Percent = 20,
			Prop = "RenegadeCreation",
		}),
		PlaceObj("Effect_GrantTech", {
			Field = "Social",
			Research = "SupportiveCommunity",
		}),
	}),

}
