-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "SolsBetweenUnlock",
		"DisplayName", T(302535920011513, "Sols Between Unlock"),
		"Help", T(302535920011514, "How many Sols to wait before unlocking the next breakthrough."),
		"DefaultValue", 10,
		"MinValue", 1,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowNotification",
		"DisplayName", T(302535920011556, "Show Notification"),
		"Help", T(302535920011557, "Show a notification when a breakthrough is unlocked."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RandomChance",
		"DisplayName", T(302535920011791, "Random Chance"),
		"Help", T(302535920011792, "If you want to gamble your chance of unlocking breakthoughs (0 = disabled)."),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ResearchBreakthroughs",
		"DisplayName", T(0000, "ResearchBreakthroughs"),
		"Help", T(0000, [[Instead of unlocking breakthroughs, this will research them.

(notification will still show as discovered)]]),
		"DefaultValue", false,
	}),
}
