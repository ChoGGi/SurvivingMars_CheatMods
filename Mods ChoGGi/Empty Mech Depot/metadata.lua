return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 7,
		}),
	},
	"title", "Empty Mech Depot",
	"version", 9,
	"version_major", 0,
	"version_minor", 9,
	"image", "Preview.png",
	"id", "ChoGGi_EmptyMechDepot",
	"steam_id", "1411108310",
	"pops_any_uuid", "c3b2ae57-aaf6-4dd1-a5ad-2bd33afd0505",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"lua_revision", 1001569,
	"description", [[Adds a button to mech depots to empty them out into a small depot in front of them.

Includes mod option to stop it from deleting mech depot afterwards.]],
})
