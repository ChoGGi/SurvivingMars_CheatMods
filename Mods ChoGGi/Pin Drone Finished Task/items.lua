-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "PinDrone",
		"DisplayName", T(302535920011656, "Pin Drone"),
		"Help", T(302535920011657, "Pin drone when task is finished."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "PinDroneIdle",
		"DisplayName", T(302535920011662, "Pin Drone Idle"),
		"Help", T(302535920011663, "Pin drone when idle."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UnpinSelectedDrone",
		"DisplayName", T(302535920011658, "Unpin Selected Drone"),
		"Help", T(302535920011659, "Unpin drone when selected (may unpin drones you don't want unpinned)."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "PauseGame",
		"DisplayName", T(302535920011660, "Pause Game"),
		"Help", T(302535920011661, "Pause game when drone task is finished."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "PauseGameIdle",
		"DisplayName", T(302535920011664, "Pause Game Idle"),
		"Help", T(302535920011665, "Pause game when drone is idle."),
		"DefaultValue", false,
	}),
}
