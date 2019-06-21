return PlaceObj("ModDef", {
	"title", "Lakes Toggle Visibility",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_LakesToggleVisibility",
	"steam_id", "1761985737",
	"pops_any_uuid", "f870ecb9-590f-427e-b1f9-9012e522c725",
	"author", "ChoGGi",
	"lua_revision", 245618,
	"code", {
		"Code/Add Entities.lua",
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[Adds a mod option to hide all lake water (if you're stuck on macos and enjoying some lag).

Mod Options:
Enable Lakes: Swap lakes with a fake ice/water texture, so you can still visually see the level
I had to adjust the level so the texture mostly stays below the ground.
Enable Grid View: As an alternate this will use a debug view instead of water (but it bleeds through entities).

You can have both options off, so it acts like the mod isn't installed (for when they release an update and you want to keep playing the save without that annoying mod missing msg).]],
})
