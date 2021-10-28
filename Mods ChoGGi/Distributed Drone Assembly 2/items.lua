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
}