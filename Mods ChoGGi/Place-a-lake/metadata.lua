return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 3,
		}),
	},
	"title", "Place-a-lake",
	"id", "ChoGGi_Placealake",
	"steam_id", "1743037328",
	"pops_any_uuid", "9f01952e-daec-4fc8-a10b-f8754a147663",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
	"TagTerraforming", true,
	"TagLandscaping", true,
	"description", [[Adds a rock you place to mark a lake spot (with a button to raise/lower the level).
This will ignore the uneven terrain limitation.

This is a purely visual mod.

Known Issues:
Rovers and whatnot will ignore the lake and walk through it.

If you want a mod that fills a lake with rain, makes the lakes improve the "Water" param, and local soil then use [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1872988552]Rain Lakes[/url] by tanyfilina.]],
})
