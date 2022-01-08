-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "BreakthroughsResearched",
		"DisplayName", T(302535920011423, "Breakthroughs Researched"),
		"Help", T(302535920011597, [[Enable to research instead of unlock breakthroughs.
You need to start a new game for this option to take effect.]]),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SortBreakthroughs",
		"DisplayName", T(302535920011600, "Sort Breakthrough List"),
		"Help", T(302535920011601, "This will sort the list of breakthroughs alphabetically (order effects in-game cost), disable for random."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ExcludeBreakthroughs",
		"DisplayName", T(302535920011635, "Exclude Breakthroughs"),
		"Help", T(302535920011636, [[Enabling a rule will stop that breakthrough from appearing.
Excluded ones replaced with random breakthroughs.
This is ignored by the All Breakthroughs rule.]]),
		"DefaultValue", false,
	}),
}
