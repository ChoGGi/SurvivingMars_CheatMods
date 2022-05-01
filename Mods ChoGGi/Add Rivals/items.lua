-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AddRivals",
		"DisplayName", T(302535920011986, "Add Rivals"),
		"DefaultValue", 3,
		"MinValue", 0,
		"MaxValue", #Presets.DumbAIDef.MissionSponsors,
	}),
}
