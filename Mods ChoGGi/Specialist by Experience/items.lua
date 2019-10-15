return {
	PlaceObj("ModItemOptionToggle", {
		"name", "IgnoreSpec",
		"DisplayName", T(302535920011473, "Override Existing Spec"),
		"Help", T(302535920011539, "If colonist is already a specialist it will be replaced."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SolsToTrain",
		"DisplayName", T(302535920011474, "Sols To Train"),
		"Help", T(302535920011540, "How many Sols of working does it take to get a spec."),
		"DefaultValue", 25,
		"MinValue", 1,
		"MaxValue", 250,
	}),
}
