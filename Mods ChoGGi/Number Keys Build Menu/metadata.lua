return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Number Keys Build Menu",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"saved", 1545134400,
	"image", "Preview.png",
	"id", "ChoGGi_NumberKeysBuildMenu",
	"steam_id", "1594874242",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Press 1-0 keys to toggle build menu for that category (Shift+number for those above).
You can rebind in options>key bindings.

Supports mod added cats.]],
})
