return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
--~ 	"title", "Spice Harvester v0.7",
	"title", "Spice Harvester v0.9",
	"version_major", 0,
	"version_minor", 9,
	"saved", 1553428800,
	"image", "Preview.png",
	"id", "ChoGGi_SpiceHarvester",
	"author", "ChoGGi",
	"code", {
		"Code/Shuttles.lua",
		"Code/Script.lua",
	},
	"steam_id", "1416040484",
	"pops_any_uuid", "a2272002-7722-4290-bf84-63afec2c1100",
	"lua_revision", LuaRevision or 243725,
	"description", [[It doesn't do much; but move around and make thumping sounds at the moment.

Anyone up for making a better model?]],
})
