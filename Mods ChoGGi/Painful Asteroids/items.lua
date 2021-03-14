-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "Enable Mod"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ImpactRange",
		"DisplayName", T(302535920011837, "Impact Range"),
		"Help", T(302535920011838, "How large of an outdomes area is affected by asteroids (default radius is multipled by this amount)."),
		"DefaultValue", 4,
		"MinValue", 1,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DomeAsteroidDeath",
		"DisplayName", T(302535920011839, "Dome + Asteroid = Death"),
		"Help", T(302535920011840, "Death of those in the dome, and any buildings inside are destroyed (also I wouldn't park rovers too close to domes)."),
		"DefaultValue", false,
	}),
}
