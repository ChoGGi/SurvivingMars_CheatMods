-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxSpawn",
		"DisplayName", T(302535920011387, "Max Spawn"),
		"Help", T(302535920011480, "Max amount to spawn."),
		"DefaultValue", 50,
		"MinValue", 0,
		"MaxValue", 1000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RandomGrazeTime",
		"DisplayName", T(0000, "Random Graze Time"),
		"Help", T(0000, "How long to Graze for (seconds)."),
		"DefaultValue", 85,
		"MinValue", 0,
		"MaxValue", 600,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RandomIdleTime",
		"DisplayName", T(0000, "Random Idle Time"),
		"Help", T(0000, "How long to Idle for (seconds)."),
		"DefaultValue", 100,
		"MinValue", 0,
		"MaxValue", 600,
	}),
}
