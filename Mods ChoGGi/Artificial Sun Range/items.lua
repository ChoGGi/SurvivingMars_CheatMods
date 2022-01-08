-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "Range",
		"DisplayName", T(302535920011581, "Range"),
		"Help", T(302535920011582, "Max Range of Artificial Sun."),
		"DefaultValue", ArtificialSun.effect_range or 8,
		"MinValue", 1,
		"MaxValue", 250,
--~ 		"StepSize", 10,
	}),
}
