return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 5,
		}),
	},
	"title", "Custom Storage Sizes",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"id", "ChoGGi_CustomStorageSizes",
	"steam_id", "2063156398",
	"pops_any_uuid", "a8fe243e-9342-4de1-9d60-723d3c733efd",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"description", [[Use mod options to set depot capacity.
Regular depots go up to 2500, mechs go to 25000.

I used "step size" for the larger depots, so it'll round the mechs to 4000 (hit reset if you want 3950).]],
})
