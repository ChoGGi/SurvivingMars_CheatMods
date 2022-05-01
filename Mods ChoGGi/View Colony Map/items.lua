-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableChallenges",
		"DisplayName", table.concat(T(754117323318, "Enable") .. " " .. T(10880, "CHALLENGES")),
		"Help", T(302535920011544, "Show map in challenges."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "AlwaysBreakthroughs",
		"DisplayName", T(0000, "Always Breakthroughs"),
		"Help", T(0000, "Always show breakthrough list."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "BreakthroughCount",
		"DisplayName", T(0000, "Breakthrough Count"),
		"Help", T(0000, [[Defaults to 12: 4 from Planetary anomalies, and 12 from ground anomalies.
	You can also get some from storybits, but those can change slightly (you could bump it up to 17 and very likely get them as well).]]),
		"DefaultValue", 12,
		"MinValue", 1,
		"MaxValue", #(Presets.TechPreset.Breakthroughs or 50),
	}),
}
