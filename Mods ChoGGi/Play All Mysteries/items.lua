-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SwitchMystery",
		"DisplayName", T(302535920012070, "Switch Mystery"),
		"Help", T(302535920012071, [[Turn this on to pick a new random mystery when you press Apply.

You will lose all progress in current mystery and it may cause unexpected issues!]]),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowMystery",
		"DisplayName", T(302535920012072, "Show Mystery"),
		"Help", T(302535920012073, "The popup msg will show the name of the new mystery."),
		"DefaultValue", false,
	}),
}
