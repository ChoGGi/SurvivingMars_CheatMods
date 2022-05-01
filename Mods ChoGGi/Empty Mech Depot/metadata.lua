return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 3,
		}),
	},
	"title", "Empty Mech Depot",
	"id", "ChoGGi_EmptyMechDepot",
	"pops_any_uuid", "c3b2ae57-aaf6-4dd1-a5ad-2bd33afd0505",
	"steam_id", "1411108310",
	"lua_revision", 1007000, -- Picard
	"version", 10,
	"version_major", 1,
	"version_minor", 0,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Adds a button to mech depots to empty them out into a small depot in front of them.

This also allows you to salvage mech depots with resources in them.
You need to enable the mod option beforehand: This will delete the resources!.

Includes mod option to stop it from deleting mech depot afterwards.
]],
})
