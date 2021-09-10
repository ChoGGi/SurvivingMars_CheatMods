-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
--~ 	PlaceObj("ModItemOptionToggle", {
--~ 		"name", "ResetTimers",
--~ 		"DisplayName", T(0000, "Reset Timers"),
--~ 		"Help", T(0000, "Reset timers on all asteroids (adds."),
--~ 		"DefaultValue", false,
--~ 	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UnlockAsteroids",
		"DisplayName", T(0000, "Unlock Asteroids"),
		"Help", T(0000, "Unlock any locked asteroids."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SpawnAsteroids",
		"DisplayName", T(0000, "Spawn Asteroids"),
		"Help", T(0000, "How many new asteroids to spawn."),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AddAsteroidTime",
		"DisplayName", T(0000, "Add Asteroid Time"),
		"Help", T(0000, "How many Sols to add to each asteroid timer."),
		"DefaultValue", 0,
		"MinValue", 0,
		"MaxValue", 100,
	}),

}
