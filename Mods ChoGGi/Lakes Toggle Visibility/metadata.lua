return PlaceObj("ModDef", {
	"title", "Lakes Toggle Visibility",
	"id", "ChoGGi_LakesToggleVisibility",
	"steam_id", "1761985737",
	"pops_any_uuid", "d6cc828d-cc4c-466b-9b07-77fec201c8ca",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
Adds a mod option to hide all lake water (if you're stuck on macos and enjoying some lag).

Mod Options:
Enable Lakes: Swap lakes with a fake ice/water texture, so you can still visually see the level.
I had to adjust the level so the texture mostly stays below the ground.
Enable Grid View: As an alternate this will use a debug view instead of water (but it bleeds through entities).

You can have both options off, so it acts like the mod isn't installed (for when they release an update and you want to keep playing the save without that annoying mod missing msg).
]],
})
