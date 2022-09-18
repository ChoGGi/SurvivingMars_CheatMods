-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DroneHubRange",
		"DisplayName", table.concat(T(8780,"MAX") .. " " .. T(3518,"Drone Hub") .. " " .. T(643,"Range")),
		"Help", T(0000, "Max range of drone hubs."),
		"DefaultValue", const.CommandCenterDefaultRadius,
		"MinValue", const.CommandCenterMinRadius,
		"MaxValue", 500,
		"StepSize", 5,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UpdateExistingHubs",
		"DisplayName", T(302535920011949, "Update Existing Hubs"),
		"Help", T(302535920011950, "Existing drone hub ranges will be updated to the new default range."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DroneHubRangeDefault",
		"DisplayName", table.concat(T(1000121,"Default") .. " " .. T(3518,"Drone Hub") .. " " .. T(643,"Range")),
		"Help", T(0000, "New hubs will have this range set by default."),
		"DefaultValue", const.CommandCenterDefaultRadius,
		"MinValue", const.CommandCenterMinRadius,
		"MaxValue", 500,
		"StepSize", 5,
	}),
}
