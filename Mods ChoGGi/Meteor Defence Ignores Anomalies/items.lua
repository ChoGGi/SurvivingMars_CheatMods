-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "IgnoreAnomalies",
		"DisplayName", T(302535920011910, "Ignore Anomalies"),
		"Help", T(302535920011911, "Don't shoot down meteors containing anomalies."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "IgnoreMetals",
		"DisplayName", T(302535920011912, "Ignore Metals"),
		"Help", T(302535920011913, "Don't shoot down meteors containing metals."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "IgnorePolymers",
		"DisplayName", T(302535920011914, "Ignore Polymers"),
		"Help", T(302535920011915, "Don't shoot down meteors containing polymers."),
		"DefaultValue", true,
	}),
}
