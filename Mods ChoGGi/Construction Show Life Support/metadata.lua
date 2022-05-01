return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 3,
		}),
	},
	"title", "Construction Show Life Support",
	"id", "ChoGGi_ConstructionShowLifeSupport",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"author", "ChoGGi",
	"image", "Preview.jpg",
	"steam_id", "2206032033",
	"pops_any_uuid", "2e8a30ad-627c-4b37-985b-ad6f5ca3b43f",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Shows life-support hexes when you're in construction mode.
Press Numpad 9 to toggle hexes anytime (rebind in game options).

Mod Options:
Show during construction: If you don't want hexes showing up during construction placement (from this mod).
Dist From Cursor: Only show hexes around buildings this close to the cursor (0 = disabled, 1 = 1000 and so on, 100 == over 2 map squares).
Hex Opacity: Set opacity of Hex icons.


Requested by DeProgrammer.
]],
})
