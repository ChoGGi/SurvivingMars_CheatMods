return {
	PlaceObj("ModItemOptionNumber", {
		"name", "SolsBetweenUnlock",
		"DisplayName", T(302535920011513, "Sols Between Unlock"),
		"Help", T(302535920011514, "How many Sols to wait before unlocking the next breakthrough."),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowNotification",
		"DisplayName", T(302535920011556, "Show Notification"),
		"Help", T(302535920011557, "Show a notification when a breakthrough is unlocked."),
		"DefaultValue", true,
	}),
}
