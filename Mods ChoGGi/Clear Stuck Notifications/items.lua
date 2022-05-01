-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "ClearMysteries",
		"DisplayName", T(0000, "Clear Mysteries"),
		"Help", T(0000, [[This will remove any mystery ones.

(excludes Mystery Log)]]),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ClearAll",
		"DisplayName", T(0000, "Clear All!"),
		"Help", T(0000, [[This will clear ALL notifications!

(excludes Mystery Log)]]),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ClearMysteryLog",
		"DisplayName", T(0000, "Clear Mystery Log"),
		"Help", T(0000, "This will remove the Mystery Log!"),
		"DefaultValue", false,
	}),
}
