return PlaceObj("ModDef", {
	"title", "Drones Use Nearest Waste Dump",
	"id", "ChoGGi_DronesUseNearestWasteDump",
	"steam_id", "3469365085",
	"pops_any_uuid", "82ce2e51-b1b4-43fd-ba74-de6a2674763b",
	"lua_revision", 1007000, -- Picard
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagGameplay", true,
	"description", [[
Drones will always use nearest wasterock dump site to drop off.


Known Issues:
Might freeze your game...
]],
})
