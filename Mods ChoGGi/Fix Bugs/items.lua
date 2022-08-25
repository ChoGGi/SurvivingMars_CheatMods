-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "FarmOxygen",
		"DisplayName", T(0000, "Farm Oxygen"),
		"Help", T(0000, [[If you remove a farm that has an oxygen producing crop (workers not needed) the oxygen will still count in the dome.

Turn off to enable cheese.
]]),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DustDevilsBlockBuilding",
		"DisplayName", T(0000, "Dust Devils Block Building"),
		"Help", T(0000, [[No more cheesing dust devils with waste rock depots (etc).

Turn off to enable cheese.
]]),
		"DefaultValue", true,
	}),
}
