-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "LowerHigher",
		"DisplayName", T(302535920011709, "Lower or Higher"),
		"Help", T(302535920011710, "On to reduce height, Off to increase."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SignHeight",
		"DisplayName", T(302535920011707, "Sign Height"),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 500,
		"StepSize", 10,
	}),
}
