-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UnlockStoryTechs",
		"DisplayName", T(0000, "Unlock Story Techs"),
		"Help", T(0000, "Unlock all story techs as well as breakthroughs."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ResearchBreakthroughs",
		"DisplayName", T(0000, "ResearchBreakthroughs"),
		"Help", T(0000, "Instead of unlocking breakthroughs, this will research them."),
		"DefaultValue", false,
	}),
}
