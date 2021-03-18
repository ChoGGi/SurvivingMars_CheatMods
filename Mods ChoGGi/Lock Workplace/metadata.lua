return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 2,
		}),
	},
	"title", "Lock Workplace",
	"version", 12,
	"version_major", 1,
	"version_minor", 2,

	"image", "Preview.png",
	"id", "ChoGGi_LockWorkplace",
	"author", "ChoGGi",
	"steam_id", "1422914403",
	"pops_any_uuid", "33d9ca4d-cc48-4676-9773-7a98b8c90328",
	"lua_revision", 1001551,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Adds a "Lock Workplace" button to the selection panel for colonists, and workplaces ("Lock Workers").
They can still be fired (if you shutdown the building/shift), they just won't change to a new workplace if they're locked.

Includes mod options to force workers to never change workplace (may cause issues).

Lock Residence: https://steamcommunity.com/sharedfiles/filedetails/?id=1635694550]],
})
