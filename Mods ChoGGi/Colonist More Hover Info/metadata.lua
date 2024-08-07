return PlaceObj("ModDef", {
	"title", "Colonist More Hover Info",
	"id", "ChoGGi_ColonistMoreHoverInfo",
	"steam_id", "2192503547",
	"pops_any_uuid", "6269bc14-c913-405e-9c27-a99e19db7781",
	"lua_revision", 1007000, -- Picard
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagInterface", true,
	"description", [[
Show more info (stats/traits) when hovering over a colonist head in the workplace selection panel.

Days trained by my Specialist by Experience mod.
Actual numbers added to traits descriptions.


Known Issues:
Because of how often the overlay checks colonists, the info I display is cached till you select a different building.


Requested by Lesandrina.
]],
})
