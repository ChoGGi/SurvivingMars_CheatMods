return PlaceObj("ModDef", {
  "title", "Lock Workplace v1.0",
  "version", 10,
  "saved", 1548504000,
	"image", "Preview.png",
  "id", "ChoGGi_LockWorkplace",
  "author", "ChoGGi",
  "steam_id", "1422914403",
  "code", {
		"Code/Script.lua",
		"Code/ModConfig.lua",
	},
	"lua_revision", LuaRevision,
  "description", [[Adds a "Lock Workplace" button to the selection panel for colonists, and workplaces ("Lock Workers").
They can still be fired (if you shutdown the building/shift), they just won't change to a new workplace if they're locked.

Includes Mod Config Reborn option to force workers to never change workplace (may cause issues).]],
})
