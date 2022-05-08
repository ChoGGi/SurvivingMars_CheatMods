return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 4,
		}),
	},
	"title", "RC Mechanic",
	"id", "ChoGGi_RCMechanic",
	"steam_id", "1528832147",
	"pops_any_uuid", "8437a4f7-7f3f-4eb1-bb14-7d09c724178c",
	"lua_revision", 1007000, -- Picard
	"version", 12,
	"version_major", 1,
	"version_minor", 2,
	"author", "ChoGGi",
	"image", "Preview.jpg",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Autonomous repair of Drones/RCs that have broken down due to driving into a dust devil or something equally smart.

This is only for malfunctioned drones.
Ignores any that are within distance of working drone hubs/rockets.
Mod option for god mode.



Known issues:
Ignores requirements and just repairs instantly. I'll see about slowing the repair down a bit.



Affectionately known as the candy striper.
]],
})
