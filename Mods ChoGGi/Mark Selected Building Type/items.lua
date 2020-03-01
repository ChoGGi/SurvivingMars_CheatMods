return {
	PlaceObj("ModItemOptionToggle", {
		"name", "Mark",
		"DisplayName", T(302535920011433, "Mark Buildings"),
		"Help", T(302535920011504, "If you want to turn off the mod disable this option."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxObjects",
		"DisplayName", T(302535920011591, "Max Objects"),
		"Help", T(302535920011592, "Skip adding lines if too many objects."),
		"DefaultValue", 100,
		"MinValue", 0,
		"MaxValue", 1000,
		"StepSize", 10,
	}),
}
