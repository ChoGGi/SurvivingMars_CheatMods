-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
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
	PlaceObj("ModItemOptionNumber", {
		"name", "DestructionPercent",
		"DisplayName", T(302535920011889, "Destruction Percent"),
		"Help", T(302535920011890, "What percentage of buildings are malfunctioned/destroyed on hit."),
		"DefaultValue", 100,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ExtraFractures",
		"DisplayName", T(302535920011891, "Extra Fractures"),
		"Help", T(302535920011892, "More dome cracks."),
		"DefaultValue", 3,
		"MinValue", 0,
		"MaxValue", 4, -- local max_visible_fractures = 4
	}),
}
