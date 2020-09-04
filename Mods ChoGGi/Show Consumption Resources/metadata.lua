return PlaceObj("ModDef", {
	"title", "Show Consumption Resources",
	"id", "ChoGGi_ShowConsumptionResources",
	"lua_revision", 249143,
	"steam_id", "2217524879",
	"pops_any_uuid", "6942fd37-2558-4116-a982-ea9b3527bb35",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagBuildings", true,
	"TagInterface", true,
	"description", [[Adds info to Consumption (and Production) tooltip to see how much material is being used at factories (or anything else that consumes resources).
It looks better in the Production tooltip, but it should be in the Consumption one, so it's in both.]],
})
