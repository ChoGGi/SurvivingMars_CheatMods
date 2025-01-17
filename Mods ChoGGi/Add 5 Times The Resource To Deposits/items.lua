-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "AllDeposits",
		"DisplayName", T(0000, "All Deposits"),
		"Help", T(0000, "Update all deposits of the same type."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MultiplyAmount",
		"DisplayName", T(0000, "Multiply Amount"),
		"Help", T(0000, "How much to multiply resource amounts by, if set to 0 then this will set amount to 1 (for removing deposit)."),
		"DefaultValue", 5,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SetGrade",
		"DisplayName", T(0000, "Set Grade"),
		"Help", T(0000, [[Set to 0 to leave grade alone.
1 = Depleted
2 = Very Low
3 = Low
4 = Average
5 = High
6 = Very High]]),
		"DefaultValue", 6,
		"MinValue", 0,
		"MaxValue", 6,
	}),
}
