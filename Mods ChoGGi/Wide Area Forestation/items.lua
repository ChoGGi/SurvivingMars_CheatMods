-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxSize",
		"DisplayName", T(302535920011643, "Max Size"),
		"Help", T(302535920011644, [[Set the max size of the forestation area.

Warning: Setting this above 200 can cause crashing, save before raising.]]),
		"DefaultValue", 200,
		"MinValue", 10,
		"MaxValue", 500,
		"StepSize", 10,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "PlantInterval",
		"DisplayName", T(302535920011645, "Plant Interval"),
		"Help", T(302535920011646, "Plant vegetation interval in hours."),
		"DefaultValue", ForestationPlant.vegetation_interval,
		"MinValue", 1,
		"MaxValue", 50,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RemovePower",
		"DisplayName", T(302535920011647, "Remove Power"),
		"Help", T(302535920011648, "Remove the requirement for electricity."),
		"DefaultValue", false,
	}),

}
