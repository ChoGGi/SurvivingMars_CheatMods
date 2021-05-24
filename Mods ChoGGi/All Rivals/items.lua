-- See LICENSE for terms

-- -2 for none and random "rivals"
local max = #Presets.DumbAIDef.MissionSponsors - 2

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxRivals",
		"DisplayName", T(302535920011651, "Max Rivals"),
		"Help", T(302535920011652, "Set the maximum amount of rivals allowed to spawn."),
		"DefaultValue", max,
		"MinValue", 3,
		"MaxValue", max,
	}),
}
