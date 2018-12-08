return PlaceObj("ModDef", {
	"title", "Patient Transport Route v0.2",
	"version", 2,
	"saved", 1540900800,
	"image", "Preview.png",
	"id", "ChoGGi_PatientTransportRoute",
	"steam_id", "1549495949",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/ModConfig.lua",
		"Code/Script.lua",
	},
	"description", [[Transports will no longer remove a route just because the supply area is empty of resources.
Instead they'll just sit by the pickup area till more shows up.

Use Mod Config Reborn to change minimum resource to wait for (default 1).]],
})
