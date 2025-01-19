-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "MrBumble",
		"DisplayName", T(302535920011354, "Bumble the wee buggers"),
		-- What? Are you some kind of pervert?
		"Help", T(302535920011543, "Stop them from using Playgrounds, and Schools (option will update all residences/workplaces/services for children)."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "MrBumbleNursery",
		"DisplayName", T(0000, "The above, but for Nurseries only"),
		"Help", T(0000, "Stop them from using Nurseries."),
		"DefaultValue", false,
	}),
}
