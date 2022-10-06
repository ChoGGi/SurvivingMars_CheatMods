-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ResourceDepotAmounts",
		"DisplayName", T(0000, "Resource Depot Amounts"),
		"Help", T(0000, "Amount resource-specific depots can store."),
		"DefaultValue", 1080,
		"MinValue", 0,
		"MaxValue", 10000,
		"StepSize", 10,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "UniversalDepotAmounts",
		"DisplayName", T(0000, "Universal Depot Amounts"),
		"Help", T(0000, "Amount universal depots can store."),
		"DefaultValue", 90,
		"MinValue", 0,
		"MaxValue", 2500,
	}),
}
