return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 8,
		}),
	},
	"title", "Unit Thoughts",
	"id", "ChoGGi_UnitThoughts",
	"lua_revision", 249143,
	"steam_id", "2196814512",
	"pops_any_uuid", "646cf5c2-b36e-40bd-b939-ab7b3fe73f06",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[Select a unit (drone/rover/colonist/shuttle) to see what it's up to.
Optionally show unit name, target, map grid target area.

Mod Options:
Enable Mod, Enable Text, Text Background, Text Opacity, Text Style
]],
})
