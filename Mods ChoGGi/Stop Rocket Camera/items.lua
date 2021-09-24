-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "StopNotificationCamera",
		"DisplayName", T(0000, "Stop Notification Camera"),
		"Help", T(0000, "Stop camera from moving to rocket when clicking notification for new trade offer."),
		"DefaultValue", true,
	}),
}
