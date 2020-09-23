return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 5,
		}),
	},
	"title", "Dome Show Connected Objects",
	"id", "ChoGGi_ShowDomeConnectedObjects",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"steam_id", "2038895989",
	"pops_any_uuid", "42e8c2ef-c183-4488-bce1-0b8b0223c7ba",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"description", [[Wondering why you can't remove a dome? This mod will show any objects that will block you from doing so.

Includes mod option to disable mod.]],
})
