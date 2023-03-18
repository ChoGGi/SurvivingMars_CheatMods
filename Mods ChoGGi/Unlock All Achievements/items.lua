-- See LICENSE for terms

return {

	PlaceObj("ModItemCode", {
		"FileName", "Code/Script.lua",
	}),

	PlaceObj("ModItemOptionToggle", {
		"name", "UnlockAllAchievements",
		"DisplayName", T(0000, "Unlock All Achievements"),
		"Help", T(0000, "Ignores installed DLC and unlocks all."),
		"DefaultValue", true,
	}),

}
