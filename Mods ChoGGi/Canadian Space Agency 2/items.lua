return {
PlaceObj("ModItemDecalEntity", {
	"name", "CSAdec",
	"comment", "Decal for Canadian Space Agency",
	"entity_name", "CanSpaAgDec",
	"display_name", "Canadian Space Agency",
	"filename", "C:/Users/admin/Documents/csa.png",
}),
PlaceObj("ModItemMissionLogo", {
	"name", "CSAlogo",
	"comment", "Logo for Canadian Space Agency",
	"entity_name", "CanSpaAgDec",
	"decal_entity", "CanSpaAgDec",
	"image", "UI/CanSpaAgDecUI.png",
	"display_name", T{234596496631, "Canadian Space Agency logo"},
}),
PlaceObj("ModItemMissionSponsor", {
	"name", "ChoGGi_CanadianSpaceAgency",
	"id", "ChoGGi_CanadianSpaceAgency",
	"comment", "We're go'in to Mars eh?",
	"display_name", T{300715699908, "Canadian Space Agency"},
	"challenge_mod", 200,
	"funding", 3500,
	"funding_per_tech", 100,
	"funding_per_breakthrough", 200,
	"applicants_per_breakthrough", 2,
	"cargo", 64000,
	"initial_rockets", 1,
	"rocket_price", 2000000000,
	"initial_techs_unlocked", 1,
	"effect", T{182713539151, [[Difficulty: <color 250 236 208>Hard</color>

Funding: $<funding> M
Research per Sol: 100
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
]]},
	"flavor", T{311546194702, [[

]]},
	"default_skin", "Star",
	"game_apply", function (self, city)
		GrantTech("DeepScanning")
	end,
	"goal", "MG_Colonists",
	"goal_target", 75,
	"modifier_name1", "Metals",
	"modifier_value1", 15,
	"sponsor_nation_name1", "American",
	"sponsor_nation_percent1", 30,
	"sponsor_nation_name2", "French",
	"sponsor_nation_percent2", 20,
	"sponsor_nation_name3", "Japanese",
	"sponsor_nation_percent3", 5,
	"sponsor_nation_name4", "Indian",
	"sponsor_nation_percent4", 5,
	"sponsor_nation_name5", "Chinese",
	"sponsor_nation_percent5", 5,
	"sponsor_nation_name6", "English",
	"sponsor_nation_percent6", 30,
	"sponsor_nation_name7", "German",
	"sponsor_nation_percent7", 5,
	"RCRover", 1,
	"ExplorerRover", 1,
	"RCTransport", 1,
	"Polymers", 15,
	"MachineParts", 15,
	"Electronics", 10,
	"OrbitalProbe", 3,
	"DroneHub", 1,
	"MoistureVaporator", 1,
	"FuelFactory", 1,
	}, {
		PlaceObj("TechEffect_ModifyLabel", {
			"Label", "Consts",
			"Prop", "ApplicantsPoolStartingSize",
			"Amount", -40,
		}),
		PlaceObj("TechEffect_ModifyLabel", {
			"Label", "Consts",
			"Prop", "MaxColonistsPerRocket",
			"Amount", -2,
		}),
		PlaceObj("TechEffect_ModifyLabel", {
			"Label", "AllRockets",
			"Prop", "travel_time",
			"Percent", 100,
		}),
		PlaceObj("TechEffect_ModifyLabel", {
			"Label", "Consts",
			"Prop", "OutsourceDisabled",
			"Amount", 1,
		}),
	}),
}
