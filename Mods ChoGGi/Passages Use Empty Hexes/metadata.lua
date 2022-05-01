return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 3,
		}),
	},
	"title", "Passages Use Empty Hexes",
	"id", "ChoGGi_PassagesUseEmptyHexes",
	"steam_id", "1809321641",
	"pops_any_uuid", "6285e6a7-f89a-47a3-a3ee-0b22e470e600",
	"lua_revision", 1007000, -- Picard
	"version", 10,
	"version_major", 1,
	"version_minor", 0,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagBuildings", true,
	"description", [[
You can place passages at hexes you normally can't build on.
Check the selection panel after placing a passage construction site, if it says "[b]Dome Connection Established[/b]" then it'll work, if it says "[b]Connection Failed![/b]" then remove the site and try elsewhere (white highlighted hexes only).

Press Numpad 6 to toggle showing usable hexes.

Mod Options:
Show usable hexes: Show hexes that can connect domes when placing passages.


Known Issues:
If something is acting funky, save then reload the game.
Doesn't seem to work on xbox?
Ramps will be ignored till you reload the save.
You will get warning messages when trying to place passages in "wrong" places (just ignore them).
I was more concerned with removing limitations than setting new ones, so you can build them in stupid places (if it doesn't place a complete passage then remove it).
Placing a passage at the life-support/entrance hex works, but you can't do a manual kink in the line.
Passages overlapping entrances can block drones/colonists from using entrance (use toggle collision button).
]],
})
