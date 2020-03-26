return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 9,
		}),
--~ 		PlaceObj("ModDependency", {
--~ 			"id", "ChoGGi_CheatMenu",
--~ 			"title", "ECM",
--~ 			"version_major", 14,
--~ 			"version_minor", 9,
--~ 		}),
	},
	"title", "Example View TextStyles",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,

	"image", "Preview.png",
	"id", "ChoGGi_ExampleViewTextStyles",
--~ 	"steam_id", "000000000",
--~ CopyToClipboard([[	"pops_any_uuid", "]] .. GetUUID() .. [[",]])
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
--~ 	"TagInterface", true,
	"description", [[dialog to display all the text styles

local dlg = ChoGGi_DlgViewTextStyles:new({}, terminal.desktop, {})
]],
})
