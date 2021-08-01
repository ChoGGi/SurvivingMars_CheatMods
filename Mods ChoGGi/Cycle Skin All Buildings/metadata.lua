return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 1,
		}),
	},
	"title", "Cycle Skin All Buildings",
	"id", "ChoGGi_CycleSkinAllBuildings",
	"steam_id", "1973703265",
	"pops_any_uuid", "bc722ad7-38a1-493d-9669-bc6fa4e8205f",
	"lua_revision", 1001514, -- Tito
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagInterface", true,
	"TagCosmetics", true,
	"TagBuildings", true,
	"description", [[Hold down Ctrl (gamepad X?) to cycle the skins of all buildings (of the same type) instead of just the selected building.
Right-click (gamepad Y?) to randomly colour the skin (change "skin" to reset colours).

Known Issues:
For objects with only one skin and a logo; the logo will disappear when changing the skin.
]],
})
