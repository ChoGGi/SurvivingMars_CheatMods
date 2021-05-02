-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "Enable Mod"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DroneHubRange",
		"DisplayName", table.concat(T(3518,"Drone Hub") .. " " .. T(643,"Range")),
		"DefaultValue", const.CommandCenterDefaultRadius,
		"MinValue", const.CommandCenterMinRadius,
		"MaxValue", 500,
		"StepSize", 5,
	}),
}
