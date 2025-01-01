-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "RandomMissionGoalsAllSponsors",
		"DisplayName", T(0000, "Random Mission Goals: All Sponsors"),
		"Help", T(0000, [[
Turn this on to have random goals no matter which sponsor you have.

This uses goals from existing sponsors, so if you have modded ones with weird goals than you might get those.
]]),
		"DefaultValue", false,
	}),

	PlaceObj("ModItemMissionSponsorPreset", {
		id = "ChoGGi_BlankSponsor_Sponsor",
		name = "ChoGGi_BlankSponsor_Sponsor",
		group = "Default",

		OrbitalProbe = 1,
		Electronics = 10,
		MachineParts = 10,
		Polymers = 10,

		RCTransport = 1,
		DroneHub = 1,
		MoistureVaporator = 1,
		StirlingGenerator = 1,

		-- eh?
		sponsor_nation_name1 = "American",
		sponsor_nation_name2 = "German",
		sponsor_nation_name3 = "Russian",
		sponsor_nation_name4 = "Chinese",
		sponsor_nation_name5 = "English",
		sponsor_nation_name6 = "Japanese",
		sponsor_nation_name7 = "Swedish",
		sponsor_nation_name8 = "French",
		sponsor_nation_percent1 = 12,
		sponsor_nation_percent2 = 12,
		sponsor_nation_percent3 = 12,
		sponsor_nation_percent4 = 12,
		sponsor_nation_percent5 = 12,
		sponsor_nation_percent6 = 12,
		sponsor_nation_percent7 = 12,
		sponsor_nation_percent8 = 12,

		display_name = T(0000, "Blank Sponsor"),
		effect = T(0000, "Blank"),
		flavor = T(0000, [[

	Nothing! Absolutely nothing!
				Kuni]]),
		initial_rockets = 1,
		initial_techs_unlocked = 1,
	}),

	PlaceObj("ModItemCommanderProfilePreset", {
		display_name = T(0000, "Blank Commander"),
		effect = T(0000, "Blank"),
		group = "Default",
		id = "ChoGGi_BlankSponsor_Commander",
	}),

}
