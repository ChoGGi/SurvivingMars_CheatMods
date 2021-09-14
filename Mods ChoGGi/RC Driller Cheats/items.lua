-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "AllowDeep",
		"DisplayName", T(302535920012062, "Allow Deep"),
		"Help", T(302535920012063, "Can exploit deep deposits."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "LossAmount",
		"DisplayName", T(302535920012064, "Loss Amount"),
		"Help", T(302535920012065, "How much is lost when using driller (0 = all, 100 = none)."),
		"DefaultValue", RCDriller.deposit_lost_pct,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ProductionPerDay",
		"DisplayName", T(302535920012066, "Production Per Day"),
		"Help", T(302535920012067, "Change how much it produces each Sol."),
		"DefaultValue", RCDriller.production_per_day / const.ResourceScale,
		"MinValue", 1,
		"MaxValue", 500,
	}),
}
