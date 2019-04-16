return PlaceObj("ModDef", {
	"title", "Example: Delay Mystery",
	"version", 20,
	"version_major", 0,
	"version_minor", 1,
	"saved", 000000000,
	"image", "Preview.png",
	"id", "ChoGGi_ExampleDelayMystery",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Looks for a gamerule id called "replace with gamerule id", if it finds it then the start of the mystery will be delayed 100 days (sols).]],
})
