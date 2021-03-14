return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 1,
		}),
	},
	"title", "List Created Objects",
	"id", "ChoGGi_ListCreatedObjects",
	"lua_revision", 249143,
--~ 	"steam_id", "000000000",
--~ CopyToClipboard([[	"pops_any_uuid", "]] .. GetUUID() .. [[",]])
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"description", [[Shows an examine list of newly created game objects]],
})
