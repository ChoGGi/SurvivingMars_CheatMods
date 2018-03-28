return PlaceObj("ModDef", {
	"title", "Cheat Menu",
	"description", "Enables the game's built-in cheat tools, as well as adding a crapload of custom menu settings. "
    .. "\nUse the F2 key to toggle the cheats menu. "
    .. "There's a cheats section in most info panels on the right side of the screen."
    .. "\nPress F4 for info about selected object (ex(Obj) for cmdline). Enter or Tilde for console."
    .. "\nFor more info see: https://github.com/ChoGGi/SurvivingMars_CheatMods (or browse the lua files)",
	"tags", "Cheats",
  --"image","",
	"id", "ChoGGi_CheatMenu",
  --"steam_id","",
	"author", "ChoGGi (thanks to chippydip, therealshibe, BoehserOnkel, Fling)",
	"version", 1,
  --"lua_revision","",
	"code", {
		"Init.lua",
	},
  --"loctables","",
  --"saved","",
})