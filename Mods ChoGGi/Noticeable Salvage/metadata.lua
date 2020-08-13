return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 4,
		}),
	},
	"title", "Noticeable Salvage",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,

	"image", "Preview.png",
	"id", "ChoGGi_NoticeableSalvage",
	"steam_id", "1814312982",
	"pops_any_uuid", "d31d1b93-a913-4e4c-bd44-36997f56887d",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"TagBuildings", true,
	"TagOther", true,
	"description", [[Changes buildings in the process of being salvaged/removed to have a black colour.]],
})
