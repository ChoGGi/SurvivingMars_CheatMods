return PlaceObj("ModDef", {
	"title", "Fix Deposits Stuck Underground",
	"id", "ChoGGi_FixDepositsStuckUnderground",
	"steam_id", "2703206312",
	"pops_any_uuid", "fea16dcd-215d-4c73-bddc-00ed0977986d",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
If you scan a surface sector that has a concrete deposit while underground then the deposit will appear underground.
This will check on load for borked ones and move them to the surface (you can also apply mod options while playing to move new ones).

https://forum.paradoxplaza.com/forum/threads/surviving-mars-surface-concrete-deposit-has-no-icon-and-is-not-minable.1496572/
]],
})
