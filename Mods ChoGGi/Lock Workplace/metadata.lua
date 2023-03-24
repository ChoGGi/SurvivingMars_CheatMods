return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 8,
		}),
	},
	"title", "Lock Workplace",
	"id", "ChoGGi_LockWorkplace",
	"steam_id", "1422914403",
	"pops_any_uuid", "33d9ca4d-cc48-4676-9773-7a98b8c90328",
	"lua_revision", 1007000, -- Picard
	"version", 15,
	"version_major", 1,
	"version_minor", 5,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Adds a "Lock Workplace" button to the selection panel for colonists, and workplaces ("Lock Workers").
They can still be fired (if you shutdown the building/shift), they just won't change to a new workplace if they're locked.

Mod Options:
Never Change: Workers will never change workplace (may cause issues).
Seniors Override: Allow graceful retirement.

Lock Residence: https://steamcommunity.com/sharedfiles/filedetails/?id=1635694550
]],
})
