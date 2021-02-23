return {
	PlaceObj("ModItemOptionToggle", {
		"name", "ColdCapacity",
		"DisplayName", T(109035890389, "Capacity"),
		"Help", T(302535920011830, "Lower the capacity of batteries as well."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "PenaltyPercent",
		"DisplayName", T(302535920011831, "Penalty Percent"),
		"Help", T(302535920011832, "Set cold penalty percent."),
		"DefaultValue", 25,
		"MinValue", 0,
		"MaxValue", 100,
	}),
}
