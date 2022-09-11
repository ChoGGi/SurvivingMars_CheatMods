-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "SpeedFour",
		"DisplayName", T(302535920012087, "Speed 4"),
		"Help", T(302535920012088, "Multiply speed of fastest speed by this."),
		"DefaultValue", 5,
		"MinValue", 0,
		"MaxValue", 500,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SpeedFive",
		"DisplayName", T(302535920012089, "Speed 5"),
		"Help", T(302535920012088, "Multiply speed of fastest speed by this."),
		"DefaultValue", 10,
		"MinValue", 0,
		"MaxValue", 500,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "OpacityStepSize",
		"DisplayName", T(0000, "Opacity Step Size"),
		"Help", T(0000, "How much to cycle through on each press."),
		"DefaultValue", 25,
		"MinValue", 0,
		"MaxValue", 100,
	}),
}