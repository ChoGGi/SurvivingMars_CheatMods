return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 3,
		}),
	},
	"title", "Disable Annoying Sounds",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.png",
	"id", "ChoGGi_DisableAnnoyingSounds",
	"steam_id", "1816633344",
	"pops_any_uuid", "03c6b6ff-1afd-489e-b923-69f171b248eb",
	"author", "ChoGGi",
	"lua_revision", 1001551,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[Stops certain sounds from happening.
Sensor Tower Beeping, RC Commander Drones Deployed, Mirror Sphere Crackling, Nursery Wailing, Spacebar Music.
Got another?

You'll need to turn off the mod option and restart if you want to re-enable any disabled sounds.]],
})
