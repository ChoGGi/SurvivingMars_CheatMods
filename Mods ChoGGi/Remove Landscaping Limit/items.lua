-- See LICENSE for terms

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
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "BlockObjects",
		"DisplayName", T(302535920011238, "Skip Blocking Objects"),
		"Help", T(302535920011532, "Turn on to be able to paint terrain near buildings. This will also allow you to place buildings in odd places."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "AllowOutOfBounds",
		"DisplayName", T(302535920011855, "Allow Out Of Bounds"),
		"Help", T(302535920011856, "Turn on to landscape out of bounds (warning can crash when used near the edge of map, save first)."),
		"DefaultValue", false,
	}),
}

