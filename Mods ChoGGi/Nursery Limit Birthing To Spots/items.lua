return {
	PlaceObj("ModItemOptionToggle", {
		"name", "GlobalDomeCount",
		"DisplayName", T(302535920011453, "All Domes Count"),
		"Help", T(302535920011509, "Check spot count of all domes instead of per-dome."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "BypassNoNurseries",
		"DisplayName", T(302535920011454, "Bypass No Nurseries"),
		"Help", T(302535920011510, "If there's no nurseries act like vanilla (otherwise no nursery == no births)."),
		"DefaultValue", true,
	}),
}
