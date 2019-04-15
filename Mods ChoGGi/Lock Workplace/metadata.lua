return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
  "title", "Lock Workplace v1.1",
	"version_major", 1,
	"version_minor", 1,
  "saved", 1548504000,
	"image", "Preview.png",
  "id", "ChoGGi_LockWorkplace",
  "author", "ChoGGi",
  "steam_id", "1422914403",
  "code", {
		"Code/Script.lua",
		"Code/ModConfig.lua",
	},
	"lua_revision", LuaRevision or 244275,
  "description", [[Adds a "Lock Workplace" button to the selection panel for colonists, and workplaces ("Lock Workers").
They can still be fired (if you shutdown the building/shift), they just won't change to a new workplace if they're locked.

Includes Mod Config Reborn option to force workers to never change workplace (may cause issues).

Lock Residence: https://steamcommunity.com/sharedfiles/filedetails/?id=1635694550]],
})
