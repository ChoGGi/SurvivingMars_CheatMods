-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "FarmOxygen",
		"DisplayName", T(0000, "Farm Oxygen"),
		"Help", T(0000, [[If you remove a farm that has an oxygen producing crop (workers not needed) the oxygen will still count in the dome.

Turn off to enable cheese and disable fix.
]]),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DustDevilsBlockBuilding",
		"DisplayName", T(0000, "Dust Devils Block Building"),
		"Help", T(0000, [[No more cheesing dust devils with waste rock depots (etc).

Turn off to enable cheese and disable fix.
]]),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "PlanetaryAnomalyBreakthroughs",
		"DisplayName", T(0000, "Planetary Anomaly Breakthroughs"),
		"Help", T(0000, [[There's no Planetary Anomaly Breakthroughs when B&B is installed.
It's probably a bug, but the underground wonders do add Breakthroughs (so I'm told).
This is here as an option for people with B&B, but don't want to do underground.

Turn off to disable this "fix" (and receieve less Breakthroughs).
]]),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UnevenTerrain",
		"DisplayName", T(0000, "Uneven Terrain"),
		"Help", T(0000, [[This calls RefreshBuildableGrid() after a landscaping project completes.

More info:
When finishing landscaping it can set some of the surrounding hexes z values (height) to 65535 (also known as UnbuildableZ).

Calling RefreshBuildableGrid() on the map seems to get rid of them without causing any major issues:
It can mark some hexes as okay to build when they weren't before, but nothing like a cliff side or anything.

If you enable the mod option and notice that you can build on some places you really shouldn't be able to then please let me know :)

If you're bored and want to dig through the funcs in LandscapeFinish() to find out exactly where it's coming from, feel free.
]]),
		"DefaultValue", false,
	}),
}
