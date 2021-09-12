-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "LightTripodRadius",
		"DisplayName", T(0000, "Light Tripod Radius"),
		"DefaultValue", BuildingTemplates.LightTripod.reveal_range,
		"MinValue", 1,
		"MaxValue", 1000,
		"StepSize", 10,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SupportStrutRadius",
		"DisplayName", T(0000, "Support Strut Radius"),
		"DefaultValue", SupportStruts.work_radius,
		"MinValue", 1,
		"MaxValue", 500,
	}),
}
