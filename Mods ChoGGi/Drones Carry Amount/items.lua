return {
	PlaceObj("ModItemOptionToggle", {
		"name", "UseCarryAmount",
		"DisplayName", T(302535920011082, "Use Carry Amount"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "CarryAmount",
		"DisplayName", T(302535920011083, "Carry Amount"),
		"DefaultValue", 5,
		"MinValue", 1,
		"MaxValue", 250,
	}),
}
