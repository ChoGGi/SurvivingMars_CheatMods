return PlaceObj("ModDef", {
	"title", "Automatic Valves",
	"id", "ChoGGi_StopLeaksAutomagically",
	"steam_id", "3454748667",
	"pops_any_uuid", "c2c1e3b6-df3e-44d0-9172-69712910d1c6",
	"lua_revision", 1007000, -- Picard
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
When a pipe or cable grid has a leak this mod tries to only turn off switches on each side of leak.
After a borked pipe/cable is repaired it'll try and turn switches back on if the grid has no more leaks.

If you have my [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374]Library[/url] mod then you can use the Ignore Switch button in the selection panel to stop certain switches from being automagically toggled.

Mod Options:
Reconnect Grids: Try to reconnect grids by turning on switches if no leaks detected.
Pipe Valves: Toggle pipe valves automagically.
Cable Switches: Toggle cable switches automagically.


This mod used to be called Stop Leaks Automagically (left here for search engines).
Requested by Funky Bigodon.
]],
})
