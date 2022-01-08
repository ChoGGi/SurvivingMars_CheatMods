-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "Enable",
		"DisplayName", T(302535920011067, "Show during construction"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AdjustLineLength",
		"DisplayName", T(302535920011351, "Adjust Line Length"),
		-- removed 5 for the angles passages (may) need
		"DefaultValue", 5,
		"MinValue", 0,
		"MaxValue", 20,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "LotsOfDomes",
		"DisplayName", T(302535920011746, "Lots Of Domes"),
		"Help", T(302535920011747, "Over this many domes and skip showing green squares (0 to ignore)."),
		"DefaultValue", 50,
		"MinValue", 1,
		"MaxValue", 250,
	}),
}
