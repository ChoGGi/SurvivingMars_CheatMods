-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DeleteGeysers",
		"DisplayName", T(302535920011870, "Delete Geysers"),
		"Help", T(302535920011871, [[Remove all geyser activity from the map (<color 255 150 150>permanent</color> per-save).
Turn this on and apply mod options, if you load a new map you will have to apply again to delete geysers from that map.
This mod option also needs "Enable Mod" turned on to work.]]),
		"DefaultValue", false,
	}),
}
