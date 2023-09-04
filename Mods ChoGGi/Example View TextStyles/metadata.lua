return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 1,
		}),
	},
	"title", "Example View TextStyles",
	"id", "ChoGGi_ExampleViewTextStyles",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"description", [[
dialog to display all the text styles

local dlg = ChoGGi_DlgViewTextStyles:new({}, terminal.desktop, {})
]],
})
