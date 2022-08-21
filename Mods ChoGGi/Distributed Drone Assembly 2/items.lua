-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "AutoPrefabDrones",
		"DisplayName", T(0000, "Auto Prefab Drones"),
		"Help", T(0000, "If less than this amount of prefabs, then queue up more to build (0 to disable)."),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "OverrideCtrlBiorobot",
		"DisplayName", T(0000, "Override Ctrl Biorobot"),
		"Help", T(0000, "Queue up more than five biorobots when holding down Ctrl."),
		"DefaultValue", 5,
		"MinValue", 1,
		"MaxValue", 250,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "OverrideCtrlDrone",
		"DisplayName", T(0000, "Override Ctrl Drone"),
		"Help", T(0000, "Queue up more than five drones when holding down Ctrl."),
		"DefaultValue", 5,
		"MinValue", 1,
		"MaxValue", 250,
	}),
}
