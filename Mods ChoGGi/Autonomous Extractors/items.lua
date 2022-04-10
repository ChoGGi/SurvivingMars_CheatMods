-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "AutoPerformance",
		"DisplayName", T(0000, "Auto Performance"),
		"Help", T(0000, "Performance value when no colonists."),
		"DefaultValue", 100,
		"MinValue", 1,
		"MaxValue", 1000,
		"StepSize", 10,
	}),
}
