-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "NewRender",
		"DisplayName", T(302535920011951, "Each Render"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "NewMinute",
		"DisplayName", T(302535920011346, "Each Minute"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "NewHour",
		"DisplayName", T(302535920011347, "Each Hour"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "NewDay",
		"DisplayName", T(302535920011348, "Each Sol"),
		"DefaultValue", true,
	}),
}
