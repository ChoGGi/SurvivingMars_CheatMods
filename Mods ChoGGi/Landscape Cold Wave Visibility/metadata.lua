return PlaceObj("ModDef", {
	"title", "Landscape Cold Wave Visibility",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,

	"image", "Preview.png",
	"id", "ChoGGi_LandscapeColdWaveVisibility",
	"steam_id", "1805456752",
	"pops_any_uuid", "f106c8cf-3621-4288-b98b-0a12afc1ad6c",
	"author", "ChoGGi",
	"lua_revision", 1001569,
	"code", {
		"Code/Script.lua",
	},
	"TagLandscaping", true,
	"TagCosmetics", true,
	"has_options", true,
	"description", [[Now you can actually see landscaping grids when a cold wave is active.

I don't think there's a way to just raise the opacity of all landscape sites, so this adds markers around them.
Includes mod option to set spacing (odd numbers seem to work better).]],
})
