-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "CleanDomes",
		"DisplayName", T(302535920011713, "Clean Domes"),
		"Help", T(302535920011714, "Cleans the dome it's in (no matter where in the dome it is)."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "WaitForIt",
		"DisplayName", T(302535920011721, "Only Clean Opened Domes"),
		"Help", T(302535920011726, "Tribby will only clean if the dome is opened."),
		"DefaultValue", false,
	}),
}
