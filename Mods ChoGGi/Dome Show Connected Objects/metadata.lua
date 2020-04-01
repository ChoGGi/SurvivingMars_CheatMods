return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 9,
		}),
	},
	"title", "Dome Show Connected Objects",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"id", "ChoGGi_ShowDomeConnectedObjects",
	"steam_id", "2038895989",
	"pops_any_uuid", "42e8c2ef-c183-4488-bce1-0b8b0223c7ba",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"TagBuildings", true,
	"description", [[Wondering why you can't remove a dome? This mod will show any objects that will block you from doing so.]],
})
