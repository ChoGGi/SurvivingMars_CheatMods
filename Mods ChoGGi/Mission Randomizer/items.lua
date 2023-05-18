-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "RandomLocation",
		"DisplayName", T(0000, "Random Location"),
		"Help", T(0000, "Turn off if you don't want a random Location."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RandomSponsor",
		"DisplayName", T(0000, "Random Sponsor"),
		"Help", T(0000, "Turn off if you don't want a random Sponsor."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RandomCommander",
		"DisplayName", T(0000, "Random Commander"),
		"Help", T(0000, "Turn off if you don't want a random Commander."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RandomMystery",
		"DisplayName", T(0000, "Random Mystery"),
		"Help", T(0000, "Turn off if you don't want a random Mystery."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "RandomLogo",
		"DisplayName", T(0000, "Random Logo"),
		"Help", T(0000, "Turn off if you don't want a random Logo."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RandomRivals",
		"DisplayName", T(0000, "Random Rivals"),
		"Help", T(0000, [[Set to 0 to not pick any rivals.


Ignored if you don't have Space Race DLC.]]),
		"DefaultValue", 3,
		"MinValue", 0,
		"MaxValue", 3,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "RandomGameRules",
		"DisplayName", T(0000, "Random Game Rules"),
		"Help", T(0000, "Set to 0 to not pick any rules."),
		"DefaultValue", 4,
		"MinValue", 0,
		"MaxValue", #(Presets.GameRules.Default or 0),
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SkipAchievementRules",
		"DisplayName", T(0000, "Skip Achievement Rules"),
		"Help", T(0000, [[Don't use rules that disable achievements.

You can use my "Game Rules Enable Achievements" mod to not have achievements when using them.]]),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "CustomGameRules",
		"DisplayName", T(0000, "Custom Game Rules"),
		"Help", T(0000, [[Turn on to have any selected rules used along with random ones.

Random Game Rules count will ignore custom.]]),
		"DefaultValue", false,
	}),
}
