-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "ToggleRain",
		"DisplayName", T(302535920012058, "Toggle Rain"),
		"Help", T(302535920012059, "Firing a rocket turns rainfall on and off."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RaiseTemps",
		"DisplayName", T(302535920012060, "Raise Temps"),
		"Help", T(302535920012061, "Raise the temperature after firing a rocket."),
		"DefaultValue", true,
	}),
--~ 	PlaceObj("ModItemOptionNumber", {
--~ 		"name", "RainType",
--~ 		"DisplayName", T(0000, "Rain Type"),
--~ 		"Help", T(0000, "0 = game start, 1 = normal, 2 = toxic"),
--~ 		"DefaultValue", 0,
--~ 		"MinValue", 0,
--~ 		"MaxValue", 2,
--~ 	}),
}