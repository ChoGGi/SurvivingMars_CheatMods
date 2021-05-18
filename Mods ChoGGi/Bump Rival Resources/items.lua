-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "Enable Mod"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "BumpPercent",
		"DisplayName", T(1000099, "Percent"),
		"DefaultValue", 5,
		"MinValue", 0,
		"MaxValue", 250,
	}),
}
