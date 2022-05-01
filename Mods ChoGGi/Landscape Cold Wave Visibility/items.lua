return {
	PlaceObj("ModItemOptionNumber", {
		"name", "SpaceCount",
		"DisplayName", table.concat(T(1000452, "Space") .. " " .. T(3732, "Count")),
		"Help", T(302535920011499, "Option to set spacing between markers (odd numbers seem to work better)."),
		"DefaultValue", 5,
		"MinValue", 1,
		"MaxValue", 25,
	}),
}
