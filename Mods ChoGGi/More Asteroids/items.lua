-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxAsteroids",
		"DisplayName", T(714746028252--[[Max Asteroids]]),
		"DefaultValue", Consts.MaxAsteroids or 3,
		"MinValue", 1,
		"MaxValue", 50,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "VerticalList",
		"DisplayName", T(0000, "Vertical List"),
		"Help", T(0000, "Displays buttons in vertical format on the left side of screen."),
		"DefaultValue", false,
	}),
}
