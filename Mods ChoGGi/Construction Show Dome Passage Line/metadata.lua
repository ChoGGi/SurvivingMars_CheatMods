return PlaceObj("ModDef", {
  "title", "Construction: Show Dome Passage Line v0.9",
  "version", 9,
  "saved", 1544702400,
  "id", "ChoGGi_ConstructionShowDomePassageLine",
  "author", "ChoGGi",
	"code", {
		"Code/ModConfig.lua",
		"Code/Script.lua",
	},
	"image", "Preview.png",
  "steam_id", "1428027914",
	"lua_revision", LuaRevision,
  "description", [[Shows lines between domes when they're close enough for passages to connect.

I use straight lines, instead of the angled passages, so it isn't perfect.
There is a chance that you'll be able to connect a dome that's another 1-3 hexes further away (dependant on the angle).
I chose to use a safe distance that'll always be close enough to connect.

Toggle in-game with Mod Config Reborn.

This doesn't take into account entrances, corners, or buildings.]],
})
