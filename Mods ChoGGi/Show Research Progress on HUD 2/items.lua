return {
	PlaceObj("ModItemOptionToggle", {
		"name", "QueueCount",
		"DisplayName", T(302535920011471, "Show Number in Queue"),
		"Help", T(302535920011537, "Show a count of the number of technologies currently in the research queue."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "HideWhenEmpty",
		"DisplayName", T(302535920011472, "Hide When Queue is Empty"),
		"Help", T(302535920011538, "When the research queue is empty, hide it entirely."),
		"DefaultValue", false,
	}),
}
