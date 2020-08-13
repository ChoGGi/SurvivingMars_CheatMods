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
	PlaceObj("ModItemOptionToggle", {
		"name", "HideSigns",
		"DisplayName", T(302535920011715, "Hide Signs"),
		"Help", T(302535920011716, "Hide signs on non-selected buildings."),
		"DefaultValue", false,
	}),
}
