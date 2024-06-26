-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "RandomBirthplace",
		"DisplayName", T(302535920011416, "Randomise Birthplace"),
		"Help", T(302535920011476, "Randomly picks birthplace for martians (so they don't all have martian names)."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DefaultNationNames",
		"DisplayName", T(302535920011417, "Default Nation Names"),
		"Help", T(302535920011477, "Existing Earth nations will not use the expanded names list."),
		"DefaultValue", true,
	}),
}
