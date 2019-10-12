return {
	PlaceObj("ModItemOptionNumber", {
		"name", "TextScale",
		"DisplayName", table.concat(T(1000145, "Text") .. " " .. T(1000081, "Scale")),
		"Help", T(302535920011478, "How big the text size is."),
		"DefaultValue", 15,
		"MinValue", 1,
		"MaxValue", 100,
--~ 		"StepSize", 100,
	}),
}
