return PlaceObj("ModDef", {
	"title", "Fix: Disable Fireworks",
	"version_major", 0,
	"version_minor", 1,
	"saved", 1555329600,
	"image", "Preview.png",
	"id", "ChoGGi_FixDisableFireworks",
--~ 	"steam_id", "000000000",
	"pops_any_uuid", "6b3568d4-ccf8-4de4-a68b-c977ed1073fe",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244124,
	"code", {
		"Code/Script.lua",
	},
	"description", [[The disable fireworks option doesn't "stick" on xbox.

Requested by MrPellaeon.]],
})
