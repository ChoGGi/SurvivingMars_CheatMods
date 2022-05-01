-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "RemovePerks",
		"DisplayName", T(302535920011760, "Remove Perks"),
		"Help", T(302535920011761, "Remove (positive) perks from newborn biorobots?"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RemoveFlaws",
		"DisplayName", T(302535920011762, "Remove Flaws"),
		"Help", T(302535920011763, "Remove (negative) flaws from newborn biorobots?"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RemoveMartianborn",
		"DisplayName", T(302535920011764, "Remove Martianborn"),
		"Help", T(302535920011765, "Remove Martianborn trait from newborn biorobots?"),
		"DefaultValue", false,
	}),
}
