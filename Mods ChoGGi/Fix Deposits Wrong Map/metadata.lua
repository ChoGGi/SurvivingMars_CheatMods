return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 3,
		}),
	},
	"title", "Fix Deposits Wrong Map",
	"id", "ChoGGi_FixDepositsStuckUnderground",
	"steam_id", "2703206312",
	"pops_any_uuid", "fea16dcd-215d-4c73-bddc-00ed0977986d",
	"lua_revision", 1007000, -- Picard
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
If you scan a surface sector that has a concrete deposit while underground then the deposit will appear underground.
This will check on load for borked ones and move them to the surface, as well as overriding the borked function to fix newly scanned.
This also fixes the underground ones stuck on the surface.

If it doesn't remove them, then go to the mod options for it and press apply.

https://forum.paradoxplaza.com/forum/threads/surviving-mars-surface-concrete-deposit-has-no-icon-and-is-not-minable.1496572/
]],
})
