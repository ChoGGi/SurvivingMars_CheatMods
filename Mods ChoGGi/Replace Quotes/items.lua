-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "RemoveQuotes",
		"DisplayName", T(0000, "Remove Quotes"),
		"Help", T(0000, "Remove all quotes/flavour from tech info (and maybe other stuff if found)."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ElonMusk",
		"DisplayName", T(0000, "Elon Musk"),
		"Help", T(0000, "Replaces Elon Musk with Nwabudike Morgan."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "VladimirPutin",
		"DisplayName", T(0000, "Vladimir Putin"),
		"Help", T(0000, "Replaces Vladimir Putin with Nikita Khrushchev."),
		"DefaultValue", false,
	}),
}
