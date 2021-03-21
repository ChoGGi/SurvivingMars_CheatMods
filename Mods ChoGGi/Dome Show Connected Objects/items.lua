-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "Enable Mod"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "CleanUpInvalid",
		"DisplayName", T(302535920011769, "Clean Up Invalid"),
		"Help", T(302535920011770, "Remove any invalid objects stuck in the dome when you press the toggle connected objs button."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "MoveInvalidPosition",
		"DisplayName", T(302535920011826, "Move Invalid Position"),
		"Help", T(302535920011827, [[Move any objects at an invalid pos to the dome when you press the toggle connected objs button.

Colonists in buildings are at invalid positions; this will skip them, but as for other stuff.]]),
		"DefaultValue", false,
	}),
}