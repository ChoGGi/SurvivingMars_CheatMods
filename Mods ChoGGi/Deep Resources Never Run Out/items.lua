return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "MaxGrade",
		"DisplayName", table.concat(T(16, "Grade") .. " " .. T(781, "Very high")),
		"Help", T(302535920011487, "Set grade to very high."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UndergroundDeposits",
		"DisplayName", table.concat(T(791, "Underground Metals") .. " " .. T(795, "Underground Water")),
		"Help", T(302535920011488, "Do the same for regular underground deposits."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SkipAsteroids",
		"DisplayName", T(0, "Skip Asteroids"),
		"Help", T(0, "Asteroid deposits don't get filled."),
		"DefaultValue", true,
	}),
}
