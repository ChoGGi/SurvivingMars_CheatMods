return {
	PlaceObj("ModItemOptionToggle", {
		"name", "NearestLaser",
		"DisplayName", T(4813, "MDS Laser"),
		"Help", T(302535920011541, "Go to the nearest working laser/missile tower if rover is idle."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "NearestHub",
		"DisplayName", T(3518, "Drone Hub"),
		"Help", T(302535920011542, "Go to the nearest working drone hub if rover is idle (laser option takes precedence)."),
		"DefaultValue", true,
	}),
}
