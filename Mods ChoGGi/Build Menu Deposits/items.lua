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
		"DisplayName", T(0000, "Underground Deposit Amount"),
		"Help", T(0000, "How many resources to spawn with deposit."),
		"DefaultValue", 5000,
		"MinValue", 0,
		"MaxValue", 500000,
		"StepSize", 1000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "VistaEffectAmount",
		"DisplayName", T(0000, "Vista Effect Amount"),
		"Help", T(0000, "How effective are Comfort/Morale boosts."),
		"DefaultValue", 25,
		"MinValue", 0,
		"MaxValue", 1000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ResearchSitePercent",
		"DisplayName", T(0000, "Research Site Percent"),
		"Help", T(0000, "How much research bonus is applied."),
		"DefaultValue", 50,
		"MinValue", 0,
		"MaxValue", 1000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AnomalyResourceAmount",
		"DisplayName", T(0000, "Anomaly Resource Amount"),
		"Help", T(0000, "How many resources per anomaly (type is random)."),
		"DefaultValue", 50,
		"MinValue", 0,
		"MaxValue", 500,
	}),
}
