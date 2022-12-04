return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 7,
		}),
	},
	"title", "Unit Thoughts",
	"id", "ChoGGi_UnitThoughts",
	"lua_revision", 1007000, -- Picard
	"steam_id", "2196814512",
	"pops_any_uuid", "6af6c908-0ed8-4ac5-90b9-1af293a8b6df",
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[
Select a unit (drone/rover/colonist/shuttle) to see what it's up to.
Optionally show unit name, target, map grid target area, drone battery life.

Mod Options:
Enable Lines, Show Names, Drone Battery Info, Only Battery Info, Force Clear Lines, Enable Mod, Enable Text, Text Background, Text Opacity, Text Style
]],
})
