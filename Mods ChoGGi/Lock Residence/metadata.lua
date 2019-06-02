return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 8,
		}),
	},
	"title", "Lock Residence",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"saved", 1548763200,
	"image", "Preview.png",
	"author", "ChoGGi",
	"id", "ChoGGi_LockResidence",
	"steam_id", "1635694550",
	"pops_any_uuid", "eaa85815-b77c-416e-a71b-e23694489348",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Adds a "Lock Residence" button to the selection panel for colonists, and residences ("Lock Residents").
They can still be kicked out (if you shutdown the building), they just won't change to a new residence if they're locked.

Includes mod options to force workers to never change residence (may cause issues).

Lock Workplace: https://steamcommunity.com/sharedfiles/filedetails/?id=1422914403]],
})
