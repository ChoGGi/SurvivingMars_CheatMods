return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 7,
		}),
	},
	"title", "Storage Toggle Drain Mode",
	"id", "ChoGGi_TankToggleDrainMode",
	"steam_id", "2214626980",
	"pops_any_uuid", "d87650c0-ced0-4755-997f-c47627550549",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagInterface", true,
	"description", [[
Adds a button to toggle drain only mode on water/air/electrical storage.
You can use this to move storage without throwing away the contents.


Requested by Vas.
]],
})
