return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 1,
		}),
	},
	"title", "Spice Harvester",
	"id", "ChoGGi_SpiceHarvester",
	"steam_id", "1416040484",
	"pops_any_uuid", "a2272002-7722-4290-bf84-63afec2c1100",
	"version", 10,
	"version_major", 1,
	"version_minor", 0,
	"lua_revision", 1007000, -- Picard
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Shuttles.lua",
		"Code/Script.lua",
	},
	"description", [[It doesn't do much; but move around and make thumping sounds at the moment.

Anyone up for making a better model?]],
})
