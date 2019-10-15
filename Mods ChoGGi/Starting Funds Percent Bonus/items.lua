return {
	PlaceObj("ModItemOptionNumber", {
		"name", "FundingPercent",
		"DisplayName", table.concat(T(3613, "Funding") .. " " .. T(1000099, "Percent")),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 250,
	}),
}
