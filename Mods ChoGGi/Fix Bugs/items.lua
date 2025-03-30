-- See LICENSE for terms

local mod_options = {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	-- keep at top
	PlaceObj("ModItemOptionToggle", {
		"name", "ColonistsWrongMap",
		"DisplayName", T(0000, "Colonists Wrong Map Infobar"),
		"Help", T(0000, [[Having B&B and colonists in the underground will cause some issues (okay having B&B will) with colonists showing up as belonging to the wrong map.

I added it as an option since this is causing issues for a user; it'll lock up on save game loading when it tries to remove some buggy objects.]]),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "UnevenTerrain",
		"DisplayName", T(0000, "Uneven Terrain"),
		"Help", T(0000, [[This calls RefreshBuildableGrid() after a landscaping project completes.
Geoscape Domes will complain about uneven terrain for spires:
I don't see why the game should be checking for uneven terrain in a dome, so... skip! (at least it should skip them, let me know if you can't build).


More info:
When finishing landscaping it can set some of the surrounding hexes z values (height) to 65535 (also known as UnbuildableZ).

Calling RefreshBuildableGrid() on the map seems to get rid of them without causing any major issues:
It can mark some hexes as okay to build when they weren't before, but nothing like a cliff side or anything.

If you enable the mod option and notice that you can build on some places you really shouldn't be able to then please let me know :)

If you're bored and want to dig through the funcs in LandscapeFinish() to find out exactly where it's coming from, feel free.
]]),
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
		"name", "XenoExtraction",
		"DisplayName", T(6616, "Xeno-Extraction"),
		"Help", T(0000, [[<color ChoGGi_red>SPOILERS!!!</color>





Dredger tech doesn't apply to newer added extractors, this changes it to apply to them:
Automatic Metals Extractor, Micro-G Extractors, RC Harvester, and RC Driller.
]]),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DustDevilsBlockBuilding",
		"DisplayName", T(0000, "Dust Devils Block Building"),
		"Help", T(0000, [[This will block you from placing a building on a dust devil to kill it.
(No more cheesing dust devils with waste rock depots)

Turn off to enable cheese and disable fix.
]]),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SupplyPodSoundEffects",
		"DisplayName", T(0000, "Supply Pod Sound Effects"),
		"Help", T(0000, [[Use the Supply Rocket sounds for the Supply Pod (since it doesn't have any).]]),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "MainMenuMusic",
		"DisplayName", T(0000, "Main Menu Music"),
		"Help", T(0000, [[If the main menu music keeps playing in-game on new games.

I added it as an option since it removes the fade out.]]),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "NoFlyingDronesUnderground",
		"DisplayName", T(0000, "No Flying Drones Underground"),
		"Help", T(0000, [[Flying drones tend to get stuck in walls/etc, this makes them into regular ones underground.

For existing drones you'll need to recall them to their hubs and redeploy.]]),
		"DefaultValue", true,
	}),
}

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return mod_options
