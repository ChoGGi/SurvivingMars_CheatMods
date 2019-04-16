return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
  "title", "Colonists: Force To New Dome",
	"version", 20,
	"version_major", 0,
	"version_minor", 4,
  "saved", 1539950400,
  "id", "ChoGGi_ColonistsForceToNewDome",
  "author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"image", "Preview.png",
  "steam_id", "1432964482",
	"lua_revision", LuaRevision or 244275,
  "description", [[Adds a menu to the dome selection panel allowing you to force colonists to migrate to a new dome.
May have to do it a couple times to make sure they're all gone.

Requested by BLAde (and probably a bunch of other people).]],
})
