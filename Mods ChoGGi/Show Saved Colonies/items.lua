-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "AmountOfSaves",
		"DisplayName", T(0000, "Amount Of Saves"),
		"Help", T(0000, "Limit visible amount of saved games (default 5)."),
		"DefaultValue", 5,
		"MinValue", 0,
		"MaxValue", 100,
	}),
}
