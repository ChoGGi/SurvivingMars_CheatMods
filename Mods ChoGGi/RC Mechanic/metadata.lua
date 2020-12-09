return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 7,
		}),
	},
	"title", "RC Mechanic",
	"id", "ChoGGi_RCMechanic",
	"steam_id", "1528832147",
	"pops_any_uuid", "9c7eb052-0151-4a3e-bdfc-9392b71264bd",
	"version", 11,
	"version_major", 1,
	"version_minor", 1,
	"author", "ChoGGi",
	"image", "Preview.jpg",
	"code", {
		"Code/Script.lua",
	},
	"lua_revision", 249143,
	"description", [[Autonomous repair of Drones/RCs that have broken down due to driving into a dust devil or something equally smart.

Ignores any that are within distance of working drone hubs/rockets.



Known issues:
Ignores requirements and just repairs instantly. I'll see about slowing the repair down a bit.



Affectionately known as the candy striper.]],
})
