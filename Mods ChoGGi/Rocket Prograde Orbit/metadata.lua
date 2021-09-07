return PlaceObj("ModDef", {
	"title", "Rocket Prograde Orbit",
	"id", "ChoGGi_RocketProgradeOrbit",
	"lua_revision", 1007000, -- Picard
	"steam_id", "2266021717",
	"pops_any_uuid", "07b69cc6-a067-4738-80ea-5fd2f457668f",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagCosmetics", true,
	"description", [[
Change the Earth rotation in the supply screen, so the rocket isn't doing a retrograde orbit.


Known Issues:
Earth spins slightly faster (and the wrong way, next update)

Requested by veryinky.
]],
})
