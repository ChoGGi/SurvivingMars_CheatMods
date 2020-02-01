return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 8,
		}),
	},
	"title", "RC Mechanic",
	"version", 10,
	"version_major", 1,
	"version_minor", 0,

	"image", "Preview.png",
	"id", "ChoGGi_RCMechanic",
	"author", "ChoGGi",
	"steam_id", "1528832147",
	"pops_any_uuid", "9c7eb052-0151-4a3e-bdfc-9392b71264bd",
	"code", {
		"Code/Script.lua",
	},
	"lua_revision", 249143,
	"description", [[Autonomous repair of Drones/RCs that have broken down due to driving into a dust devil or something equally smart.

Ignores any that are within distance of working drone hubs/rockets.



Known issues:
Ignores requirements and just repairs instantly. I'll see about slowing the repair down a bit.
It's got god mod. It is intentional, but that might be an issue for some people...



Affectionately known as the candy striper.]],
})
