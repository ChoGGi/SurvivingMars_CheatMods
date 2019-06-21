return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 0,
		}),
	},
--~ 	"title", "Outside Residence",
	"title", "MARSHA",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_OutsideResidence",
	"steam_id", "1775121099",
	"pops_any_uuid", "8f3295f3-b7bb-4a5c-a81e-1876271c28d1",
	"author", "ChoGGi",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"TagBuildings", true,
	"description", [[Stores some colonists outside.
The building feeds off the nearest dome and has low comfort, but it only needs concrete for maintenance.

30 concrete, 5 polymers to build
maintenance 5 concrete, elec consump 16, capacity 18


Requested by Destrada.]],
})
