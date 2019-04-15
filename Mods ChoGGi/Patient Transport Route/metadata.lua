return PlaceObj("ModDef", {
	"title", "Patient Transport Route",
	"version_major", 0,
	"version_minor", 2,
	"saved", 1540900800,
	"image", "Preview.png",
	"id", "ChoGGi_PatientTransportRoute",
	"steam_id", "1549495949",
	"pops_any_uuid", "0f27c2bc-c79e-451f-8269-1562b6abf699",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/ModConfig.lua",
		"Code/Script.lua",
	},
	"description", [[Transports will no longer remove a route just because the supply area is empty of resources.
Instead they'll just sit by the pickup area till more shows up.

Use Mod Config Reborn to change minimum resource to wait for (default 1).]],
})
