return {
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
}
