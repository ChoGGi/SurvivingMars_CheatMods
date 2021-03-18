return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 2,
		}),
	},
	"title", "Named Workplaces",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"id", "ChoGGi_NamedWorkplaces",
	"steam_id", "1822631100",
	"pops_any_uuid", "dd48a2c8-9647-494c-ac21-0d11eb0534fc",
	"author", "ChoGGi",
	"lua_revision", 1001551,
	"code", {
		"Code/Script.lua",
	},
	"TagCosmetics", true,
	"TagOther", true,
	"description", [[Workplaces are named after the first person to work in it.
Translations would be nice, the string I use is: "<name>'s <workplace>, est. <sol>"


You can thank mrudat for the idea.]],
})
