return PlaceObj("ModDef", {
	"title", "Stop Leaks Automagically",
	"id", "ChoGGi_StopLeaksAutomagically",
	"steam_id", "3454748667",
	"pops_any_uuid", "c2c1e3b6-df3e-44d0-9172-69712910d1c6",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
When a pipe or cable grid has a leak turn off all switches on the same grid.
After a borked pipe/cable is repaired it'll try and turn switches back on if the grid has no more leaks.

Mod Options:
Reconnect Grids: Try to reconnect grids by turning on switches if no leaks detected.
Pipe Valves: Toggle pipe valves automagically.
Cable Switches: Toggle cable switches automagically.


Requested by Funky Bigodon.
]],
})
