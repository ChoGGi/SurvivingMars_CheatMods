-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ScrollBorderSize",
		"DisplayName", T(302535920011952, "Scroll Border Size"),
		"Help", T(302535920011953, [[-1: Disable mouse border scrolling, WASD works fine.
0-2: Down scrolling may not work (dependant on aspect ratio?).
3+ activation size of border.]]),
		"DefaultValue", const.DefaultCameraRTS.ScrollBorder or 5,
		"MinValue", -1,
		"MaxValue", 50,
	}),
}
