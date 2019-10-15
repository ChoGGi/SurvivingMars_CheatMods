return {
	PlaceObj("ModItemOptionNumber", {
		"name", "StepSize",
		"DisplayName", T(302535920011237, "Step Size"),
		"Help", T(302535920011531, "How much to adjust the size of the landscaping area by."),
		"DefaultValue", 10,
		"MinValue", 1,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RemoveLandScapingLimits",
		"DisplayName", T(302535920011238, "Remove Landscaping Limits"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "BlockObjects",
		"DisplayName", T(302535920011238, "Skip Blocking Objects"),
		"Help", T(302535920011532, "Enable to be able to paint terrain near buildings. This will also allow you to place buildings in odd places."),
		"DefaultValue", false,
	}),
}

