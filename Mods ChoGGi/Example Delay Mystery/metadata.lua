return PlaceObj("ModDef", {
	"title", "Example: Delay Mystery v0.1",
	"version", 1,
	"saved", 000000000,
	"image", "Preview.png",
	"id", "ChoGGi_ExampleDelayMystery",
--~ 	"steam_id", "000000000",
--~ 	"pops_any_uuid", GetUUID(),
--~ 	"pops_desktop_uuid", GetUUID(),
--~ CopyToClipboard(string.format([["pops_any_uuid", "%s",]],GetUUID()))
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Looks for a gamerule id called "replace with gamerule id", if it finds it then the start of the mystery will be delayed 100 days (sols).]],
})
