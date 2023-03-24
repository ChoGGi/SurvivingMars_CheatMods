return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 8,
		}),
	},
	"title", "No More Outside Suffocation",
	"id", "ChoGGi_NoMoreOutsideSuffocation",
	"steam_id", "2794807829",
	"pops_any_uuid", "634b1bed-c718-48ce-ab95-4f8de6325421",
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
	"TagOther", true,
	"description", [[
Colonists like to walk from a dome on one side of the map to the other and keel over on the way.
I've had no luck getting them to stop doing that, so...
This changes the amount of oxygen time they have (from 4 hours to 100 Sols).
Changes dehydration outside as well.

This won't stop them from dying from lack of oxygen inside a dome/building.
]],
})
