return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Bottomless Storage",
	"version_major", 0,
	"version_minor", 4,
	"saved", 1534680000,
	"image", "Preview.png",
	"id", "ChoGGi_BottomlessStorage",
	"author", "ChoGGi",
	"steam_id", "1411102605",
	"code", {
		"Code/Script.lua",
	},
	"lua_revision", LuaRevision or 244124,
	"description", [[Anything added to this storage depot will disappear (good for excess resources).

Be careful where you place it as drones will use it like a regular depot (defaults to no resources accepted).]],
})
