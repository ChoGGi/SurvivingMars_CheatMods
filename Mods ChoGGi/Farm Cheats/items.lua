-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "CropsNeverFail",
		"DisplayName", T(302535920011851, "Crops Never Fail"),
		"Help", T(302535920011852, "Crops will never fail no matter the conditions (you'll get a random yield amount instead of failing)."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ConstantSoilQuality",
		"DisplayName", T(302535920011853, "Constant Soil Quality"),
		"Help", T(302535920011854, "Soil quality will always be this amount (0 to disable)."),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 1000,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "MechFarming",
		"DisplayName", T(302535920012081, "Mech Farming"),
		"Help", T(302535920012082, "Workers not needed."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MechPerformance",
		"DisplayName", T(302535920012083, "Mech Performance"),
		"Help", T(302535920012084, "How much performance each farm does without fleshbags."),
		"DefaultValue", 100,
		"MinValue", 1,
		"MaxValue", 1000,
	}),
}
