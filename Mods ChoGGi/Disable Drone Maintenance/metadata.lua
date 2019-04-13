return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
  "title", "Disable Drone Maintenance v1.0",
	"version_major", 1,
	"version_minor", 0,
  "saved", 1543060800,
	"image", "Preview.png",
  "id", "ChoGGi_DisableDroneMaintenance",
  "author", "ChoGGi",
  "steam_id", "1411107464",
  "code", {
		"Code/Script.lua",
	},
	"lua_revision", LuaRevision or 244124,
  "description", [[Adds a menu button to buildings to disable drones from performing maintenance (on all of type or just selected).]],
})
