-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RefabEverything",
		"DisplayName", T(0000, "Refab Everything"),
		"Help", T(0000, [[Unlocks Refab button for everything (to disable restart game).

WARNING: This will allow you to refab stuff you shouldn't refab (like underground entrance), be careful what you refab.
		]]),
		"DefaultValue", false,
	}),
}
