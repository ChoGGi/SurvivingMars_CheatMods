-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DepositAmount",
		"DisplayName", T(0000, "Deposit Amount"),
		"Help", T(0000, "How many resources to spawn with deposit."),
		"DefaultValue", 5000,
		"MinValue", 0,
		"MaxValue", 500000,
		"StepSize", 1000,
	}),
}
