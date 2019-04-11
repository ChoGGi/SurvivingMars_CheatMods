return PlaceObj("ModDef", {
	"title", "Command Center Distance Sort v0.2",
	"version", 2,
	"saved", 1551182400,
	"image", "Preview.png",
	"id", "ChoGGi_CommandCenterDistanceSort",
	"steam_id", "1655735750",
	"pops_any_uuid", "820b006e-9e01-4bd0-a706-0917008262ac",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244124,
	"code", {
		"Code/Script.lua",
	},
	"description", [[On load and every new Sol this will sort the cc list of each building by distance.
Hopefully makes the drones use the nearest first, but it's quite fast so feel free to leave it enabled.]],
})
