return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
  "title", "RC Mechanic",
	"version", 20,
	"version_major", 0,
	"version_minor", 7,
  "saved", 1543060800,
	"image", "Preview.png",
  "tags", "Buildings",
  "id", "ChoGGi_RCMechanic",
  "author", "ChoGGi",
  "steam_id", "1528832147",
	"pops_any_uuid", "9c7eb052-0151-4a3e-bdfc-9392b71264bd",
  "code", {
		"Code/Script.lua",
	},
	"lua_revision", LuaRevision or 244275,
  "description", [[Autonomous repair of Drones/RCs that have broken down due to driving into a dust devil or something equally smart.

Ignores any that are within distance of working drone hubs/rockets.



Known issues:
Ignores requirements and just repairs instantly. I'll see about slowing the repair down a bit.
It's got god mod. It is intentional, but that might be an issue for some people...



Affectionately known as the candy striper.]],
})
