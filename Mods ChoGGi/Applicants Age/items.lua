-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxAge",
		"DisplayName", T(0000, "Max Age"),
		"Help", T(0000, "Applicants over this age are removed from the applicant pool (Mid aged are 31, Senior are 61)."),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 150,
	}),
}
