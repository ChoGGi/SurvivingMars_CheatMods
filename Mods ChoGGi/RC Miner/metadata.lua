return PlaceObj("ModDef", {
  "title", "RC Miner v1.5",
  "version", 15,
  "saved", 1540296000,
	"image", "Preview.png",
  "tags", "Buildings",
  "id", "ChoGGi_PortableMiner",
  "author", "ChoGGi",
  "steam_id", "1411113412",
  "code", {
		"Code/Script.lua",
		"Code/ModConfig.lua",
	},
	"lua_revision", LuaRevision,
  "description", [[It's a rover that mines, tell it where to go and if there's a resource (Metals/Concrete) close by it'll start mining it.
Supports the Auto-mode added in Sagan (boosts the amount stored per stockpile when enabled).
Use ModConfig to tweak the settings.

Uses the Attack Rover model (check script.lua to change it to something else).



Affectionately known as the pooper shooter.]],
})
