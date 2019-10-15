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
		"Help", T(302535920011510, "If there's no nurseries act like vanilla."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RespectIncubator",
		"DisplayName", T(302535920011455, "Respect Incubator"),
		"Help", T(302535920011511, "Allow SkiRich's Incubator mod to relocate newborns to incubator dome."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UltimateNursery",
		"DisplayName", T(302535920011456, "Ultimate Nursery"),
		"Help", T(302535920011512, "Count Ultimate Nurseries INSTEAD of regular ones."),
		"DefaultValue", true,
	}),
}
