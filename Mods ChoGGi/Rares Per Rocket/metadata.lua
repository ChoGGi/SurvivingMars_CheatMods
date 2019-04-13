return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Rares Per Rocket",
--~ 	"title", "Rares Per Rocket v0.3",
	"version_major", 0,
	"version_minor", 3,
	"saved", 1555070400,
	"image", "Preview.png",
	"id", "ChoGGi_RaresPerRocket",
--~ 	"steam_id", "000000000",
	"pops_any_uuid", "6ba1c4f3-0855-450f-881a-0d33b5f6f64a",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244124,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Default to 90 rares per rocket.

Requested by Mrpellaeon.]],

	"has_options", true,
})
