return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
--~	 "title", "Martian Carwash v0.5",
	"title", "Martian Carwash",
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"saved", 1551960000,
	"image", "Preview.png",
	"id", "ChoGGi_MartianCarwash",
	"author", "ChoGGi",
	"steam_id", "1411110474",
	"pops_any_uuid", "c146c971-70c2-41da-92ea-3cb7c3d9c6b7",
	"code", {
		"Code/Script.lua"
	},
	"lua_revision", LuaRevision or 244275,
	"description", [[Drive your ride through our full service car wash. You don't want to drive a dirty ride, and you shouldn't have to look at one.

This only affects visuals, not maintenance points.]],
})
