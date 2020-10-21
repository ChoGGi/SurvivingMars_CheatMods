return {
	PlaceObj("ModItemOptionNumber", {
		"name", "BuildDist",
		"DisplayName", T(302535920011079, "Build Distance"),
		"Help", T(302535920011491, "How many hexes you can build."),
		"DefaultValue", GridConstructionController.max_hex_distance_to_allow_build or 20,
		"MinValue", 10,
		"MaxValue", 1000,
		"StepSize", 10,
	}),
}
