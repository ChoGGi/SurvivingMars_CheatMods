return PlaceObj("ModDef", {
	"title", "Dome Birth Progress",
	"version_major", 0,
	"version_minor", 1,
	"saved", 1545480000,
	"image", "Preview.png",
	"id", "ChoGGi_DomeBirthProgress",
	"steam_id", "1598169148",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244124,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Shows a percent build up to when children are spawned.
Once it hits a hundred, it'll slowly tick down afterwards to around zero (then back up again).

This is just a visual mod to let you know what's going on birth rate wise.]],
})
