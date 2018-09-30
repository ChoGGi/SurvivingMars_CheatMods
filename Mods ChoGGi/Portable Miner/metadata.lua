return PlaceObj("ModDef", {
  "title", "Portable Miner v0.9",
  "version", 9,
  "saved", 1538222400,
	"image", "Preview.png",
  "tags", "Buildings",
  "id", "ChoGGi_PortableMiner",
  "author", "ChoGGi",
  "steam_id", "1411113412",
  "code", {
		"Code/Script.lua",
	},
	"lua_revision", LuaRevision,
  "description", [[It's a rover that mines, tell it where to go and if there's a resource (Metals/Concrete) close by it'll start mining it.
Supports the Auto-mode added in Sagan (boosts the amount stored per stockpile when enabled).

Uses the Attack Rover model (check script.lua to change it to something else).



Known Issues:
The ground where concrete is mined won't change.



Affectionately known as the pooper shooter.]],
})
