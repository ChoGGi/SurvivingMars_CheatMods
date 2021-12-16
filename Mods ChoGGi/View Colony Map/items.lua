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
}
