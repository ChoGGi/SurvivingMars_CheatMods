return PlaceObj("ModDef", {
	"title", "Construction Show Max Radius Range",
	"id", "ChoGGi_ShowMaxRadiusRange",
	"steam_id", "1522200776",
	"pops_any_uuid", "f11ce232-278a-422e-b12d-476f9a148d1c",
	"lua_revision", 1007000, -- Picard
	"version", 15,
	"version_major", 1,
	"version_minor", 5,
	"code", {
		"Code/Script.lua",
	},
	"author", "ChoGGi",
	"image", "Preview.jpg",
	"has_options", true,
	"description", [[
Shows maxed grid for ranged buildings when in construction mode.
Ranged buildings:
Triboelectric Scrubber / Triboelectric Sensor Tower
Subsurface Heater
Core Heat Convector
Forestation Plant
Drone Hub

This also shows a circle for any heater buildings (since they heat a circle).

Mod Options:
Show during construction: Toggle in-game.
Set Max Radius: Set radius for newly placed buildings to max radius.


Not exactly requested by MGoods.
]],
})
