-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ClearOnLaunch",
		"DisplayName", T(302535920011469, "Clear On Launch"),
		"Help", T(302535920011536, "Clear cargo for rocket/pod/elevator when launched (not all cargo, just for the same type)."),
		"DefaultValue", false,
	}),
}
