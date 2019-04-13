return PlaceObj("ModDef", {
--~   "title", "Specialist By Experience v0.4",
  "title", "Specialist By Experience v0.5",
	"version_major", 0,
	"version_minor", 5,
  "saved", 1553342400,
  "id", "ChoGGi_SpecialistByExperience",
  "author", "ChoGGi",
	"code", {
		"Code/Script.lua",
		"Code/ModConfig.lua",
	},
	"image", "Preview.png",
  "steam_id", "1461190633",
	"pops_any_uuid", "16aa5fa7-f019-4772-92a5-7dd977a35322",
	"lua_revision", LuaRevision or 243725,
  "description", [[Colonists that work at the same job for 25 Sols will automagically get the specialisation needed for that workplace.

Does not include colonists that already have a spec (you can allow that with Mod Config Reborn).
Works on saved games, but only on newly hired colonists (you can use Expanded Cheat Menu to fire everyone).

Idea by Dragonmystic.]],
})
