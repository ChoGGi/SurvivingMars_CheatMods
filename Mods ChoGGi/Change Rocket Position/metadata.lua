return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 8,
		}),
	},
	"title", "Change Rocket Position",
	"id", "ChoGGi_ChangeRocketPosition",
	"steam_id", "1707472695",
	"pops_any_uuid", "d7bd5fe9-ebb5-4800-ace3-4d66c8f53d8f",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"lua_revision", 1001514, -- Tito
	"code", {
		"Code/Script.lua",
	},
	"description", [[Adds a button to rockets that lets you re-position the rocket.
Costs 10 fuel per re-position.


Known Issues:
Any stored rare metals will get "delivered" to Earth.]],
})
