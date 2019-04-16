return PlaceObj("ModDef", {
  "title", "Fix: Missing Mod Buildings",
	"version", 20,
	"version_major", 0,
	"version_minor", 4,
  "saved", 1534680000,
	"image", "Preview.png",
  "tags", "Buildings",
  "id", "ChoGGi_MissingModBuildings",
  "author", "ChoGGi",
  "steam_id", "1443225581",
  "code", {
		"Code/Script.lua"
	},
	"lua_revision", LuaRevision or 244275,
  "description", [[This replaces my Missing Residences/Missing Workplaces mods, it also adds support for some other missing buildings.

If you installed a mod that adds certain buildings, then removed the mod without removing them; your game won't load...

This fixes that, and will remove any broked buildings.

You can remove this mod after saving your game, or leave it enabled.




BACKUP your save before using this.


]],
})
