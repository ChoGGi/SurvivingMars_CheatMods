return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
  "title", "Lock Residence v0.3",
  "version", 3,
  "saved", 1548763200,
	"image", "Preview.png",
  "id", "ChoGGi_LockResidence",
  "author", "ChoGGi",
	"steam_id", "1635694550",
  "code", {
		"Code/Script.lua",
		"Code/ModConfig.lua",
	},
	"lua_revision", LuaRevision or 243725,
  "description", [[Adds a "Lock Residence" button to the selection panel for colonists, and residences ("Lock Residents").
They can still be kicked out (if you shutdown the building), they just won't change to a new residence if they're locked.

Includes Mod Config Reborn option to force workers to never change residence (may cause issues).

Lock Workplace: https://steamcommunity.com/sharedfiles/filedetails/?id=1422914403]],
})
