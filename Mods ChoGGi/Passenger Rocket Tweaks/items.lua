return {
	PlaceObj("ModItemOptionToggle", {
		"name", "HideRocket",
		"DisplayName", T(302535920011127, "Hide Background"),
		"Help", T(302535920011520, "Shows a black background so you can see the text easier."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "MoreSpecInfo",
		"DisplayName", T(302535920011128, "More Spec Info"),
		"Help", T(302535920011521, "Add a specialisation count section to the passenger rocket screen (selected applicants / specialists needed by workplaces / specialists already in colony)."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "PosPassList",
		"DisplayName", (302535920011129, "Position Pass List"),
		"Help", T(302535920011522, "Enable changing position of passenger list."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "PosX",
		"DisplayName", T(302535920011130, "X Margin"),
		"Help", T(302535920011523, "Margin to use for passenger list."),
		"DefaultValue", 700,
		"MinValue", 1,
		"MaxValue", 1000,
		"StepSize", 10,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "PosY",
		"DisplayName", T(302535920011131, "Y Margin"),
		"Help", T(302535920011523, "Margin to use for passenger list."),
		"DefaultValue", 500,
		"MinValue", 1,
		"MaxValue", 1000,
		"StepSize", 10,
	}),
}
