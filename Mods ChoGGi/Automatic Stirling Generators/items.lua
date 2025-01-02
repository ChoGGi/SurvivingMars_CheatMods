-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "Shift1",
		"DisplayName", T(0000, "Shift 1 Morning (6-14)"),
		"Help", T(0000, "Turn on to open during this shift, off to close"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "Shift2",
		"DisplayName", T(0000, "Shift 2 Afternoon (14-22)"),
		"Help", T(0000, "Turn on to open during this shift, off to close"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "Shift3",
		"DisplayName", T(0000, "Shift 3 Night (22-6)"),
		"Help", T(0000, "Turn on to open during this shift, off to close"),
		"DefaultValue", true,
	}),
}
