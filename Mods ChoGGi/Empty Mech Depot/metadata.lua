return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
  "title", "Empty Mech Depot v0.7",
  "version", 7,
  "saved", 1539950400,
	"image", "Preview.png",
  "tags", "Building",
  "id", "ChoGGi_EmptyMechDepot",
  "steam_id", "1411108310",
  "author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"lua_revision", LuaRevision or 243725,
  "description", [[Adds a button to mech depots to empty them out into a small depot in front of them.]],
})
