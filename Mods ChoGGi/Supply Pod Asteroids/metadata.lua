return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 10,
			"version_minor", 6,
		}),
	},
	"title", "Supply Pod Asteroids",
	"id", "ChoGGi_SupplyPodAsteroids",
	"steam_id", "2629830000",
	"pops_any_uuid", "d27e1395-9060-4978-8279-b4fb26dc39e5",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
You can land supply pods on asteroids.


Known Issues:
Just because you can land a rover doesn't mean the devs expected you to.

Requested by Blade.
]],
})
