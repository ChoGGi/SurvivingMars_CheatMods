return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 0,
		}),
	},
	"title", "Passages Use Empty Hexes",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.png",
	"id", "ChoGGi_PassagesUseEmptyHexes",
	"steam_id", "1809321641",
	"pops_any_uuid", "2273f89a-7721-4550-b777-024352538af9",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[You can put passages anywhere, but only certain hexes will "connect" domes.
Check the selection panel after placing a passage construction site, if it says "Connected to building" then it'll work, if it says "No dome" then remove the site and try again.


Mod Options:
Show usable hexes: Show hexes that can connect domes when placing passages.

Press Numpad 6 to toggle showing usable hexes.


Known Issues:
You will get warning messages when trying to place passages in "wrong" places (just ignore them).
I was more concerned with removing limitations than setting new ones, so you can build them in stupid places (if it doesn't place a complete passage then remove it).
Placing a passage at the life-support/entrance hex works, but you can't do a manual kink in the line.
Passages overlapping entrances can block drones/colonists.
]],
})
