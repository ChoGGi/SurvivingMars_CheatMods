-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "TextScale",
		"DisplayName", table.concat(T(1000145, "Text") .. " " .. T(1000081, "Scale")),
		"Help", T(302535920011771, "How big the text size is."),
		"DefaultValue", 15,
		"MinValue", 1,
		"MaxValue", 100,
--~ 		"StepSize", 100,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowText",
		"DisplayName", T(302535920011772, "Show Text"),
		"Help", T(302535920011773, "Use this to turn off text when in construction mode."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "CompactText",
		"DisplayName", T(302535920011774, "Compact Text"),
		"Help", T(302535920011775, "Just show count/icon for construction mode text."),
		"DefaultValue", false,
	}),
}
