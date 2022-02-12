-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxDeposits",
		"DisplayName", T(0000, "Max Deposits"),
		"Help", T(0000, "Max amount to spawn around actual deposits."),
		"DefaultValue", 8,
		"MinValue", 1,
		"MaxValue", 250,
	}),
}
