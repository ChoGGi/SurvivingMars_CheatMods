-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxRubble",
		"DisplayName", T(0000, "Max Rubble"),
		"Help", T(0000, "How many rubble rocks to spawn."),
		"DefaultValue", 10000,
		"MinValue", 0,
		"MaxValue", 50000,
		"StepSize", 100,
	}),
}

