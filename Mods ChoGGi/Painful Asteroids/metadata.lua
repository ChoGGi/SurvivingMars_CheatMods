return PlaceObj("ModDef", {
	"title", "Painful Asteroids",
	"id", "ChoGGi_PainfulAsteroids",
	"lua_revision", 1001551,
	"steam_id", "2424938510",
	"pops_any_uuid", "c6fa07e9-c83a-4f86-89a7-b7c1a390bebd",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[Makes the dome and any buildings inside it malfunction on impact.
This also increases the damage area when landing outside domes (see mod option to adjust).

Mod Options:
Dome + Asteroid = Death: Death of those in the dome, and any buildings inside are destroyed (also I wouldn't park rovers too close to domes).
Impact Range: How large of an outdomes area is affected by asteroids.
]],
})
