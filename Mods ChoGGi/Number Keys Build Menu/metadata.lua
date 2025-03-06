return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 5,
		}),
	},
	"title", "Number Keys Build Menu",
	"id", "ChoGGi_NumberKeysBuildMenu",
	"steam_id", "1594874242",
	"pops_any_uuid", "5e0057b9-4f8d-46e2-918b-ad161e4df697",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"description", [[Press 1-0 keys to toggle build menu for that category (Shift+number for those above).
You can rebind in options>key bindings.

Supports mod added cats.]],
})
