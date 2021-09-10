return PlaceObj("ModDef", {
	"title", "Upgrade Capacity",
	"id", "ChoGGi_UpgradeSlotsVisitorsCapacity",
	"pops_any_uuid", "f73b0344-9d78-4489-91d3-4c42a37d581c",
	"steam_id", "1767471811",
	"lua_revision", 1007000, -- Picard
	"version", 8,
	"version_major", 0,
	"version_minor", 8,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagInterface", true,
	"description", [[
Adds upgrades to increase the capacity (also increases electricity consumption) of residences, services, etc.
Existing upgrade for the building == skip these upgrades (it will boost cap of upgrade 2).
]],
})
