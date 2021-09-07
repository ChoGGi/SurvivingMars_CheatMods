-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SafeLanding",
		"DisplayName", T(302535920012040, "Safe Landing"),
		"Help", T(302535920012041, "Buildings won't be hit by falling rocks."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MetalsThreshold",
		"DisplayName", T(302535920012042, "Metals Threshold"),
		"Help", T(302535920012043, "Threshold for a new Metals deposit."),
		"DefaultValue", 5,
		"MinValue", 1,
		"MaxValue", 50,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RareMetalsThreshold",
		"DisplayName", T(302535920012044, "Rare Metals Threshold"),
		"Help", T(302535920012045, "Threshold for a new Rare Metals deposit."),
		"DefaultValue", 3,
		"MinValue", 1,
		"MaxValue", 50,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "WaterThreshold",
		"DisplayName", T(302535920012046, "Water Threshold"),
		"Help", T(302535920012047, "Threshold for a new Water deposit."),
		"DefaultValue", 6,
		"MinValue", 1,
		"MaxValue", 50,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ConcreteThreshold",
		"DisplayName", T(302535920012048, "Concrete Threshold"),
		"Help", T(302535920012049, "Threshold for a new Concrete deposit."),
		"DefaultValue", 8,
		"MinValue", 1,
		"MaxValue", 50,
	}),
}
