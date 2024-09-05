-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "AmountOfWater",
		"DisplayName", T(302535920011479, "Water Per Sol"),
		"Help", T(302535920011386, "How much water each deposit receives each Sol."),
		"DefaultValue", 50,
		"MinValue", 0,
		"MaxValue", 1000,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "FollowWaterParameter",
		"DisplayName", T(0000, "Follow Water Parameter"),
		"Help", T(0000, "Ignore Water Per Sol and add water based on water terraforming parameter."),
		"DefaultValue", false,
	}),
}
