return {
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowMetals",
		"DisplayName", T(302535920011374, "Show Metals"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowPolymers",
		"DisplayName", T(302535920011375, "Show Polymers"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "TextBackground",
		"DisplayName", T(302535920011376, "Text Background"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "TextOpacity",
		"DisplayName", T(302535920011377, "Text Opacity"),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 255,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "TextStyle",
		"DisplayName", T(302535920011378, "Text Style"),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 10,
	}),
}
