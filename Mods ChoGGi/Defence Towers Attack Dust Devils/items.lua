-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UnlockDefenseTowers",
		"DisplayName", table.concat(T(2, "Unlock Tech") .. " " .. T(7301, "Defence Turret")),
		"Help", T(302535920011994, "Start with towers unlocked (needed unless playing mystery that unlocks them)."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "IgnoreMeteors",
		"DisplayName", T(0000, "Ignore Meteors"),
		"Help", T(0000, "Turn on to have towers ignore meteors."),
		"DefaultValue", false,
	}),
}
