return PlaceObj("ModDef", {
	"title", "Cheat Menu Expanded",
	"description", "Enables the game's built-in cheat tools, as well as adding a crapload of custom menu settings. "
    .. "There's a cheats section in most info panels on the right side of the screen."
    .. "\n\nF2: Toggle the cheats menu.."
    .. "\nF4: Open object examiner for selected object (use ex(Object) in console)."
    .. "\nEnter or Tilde to show the console."
    .. "\nF9 to clear the console log."
    .. "\nCtrl-Alt-Shift-R: opens console and places \"restart\" in it."
    .. "\nCtrl+F: Fill resource of selected object."
    .. "\nCtrl-Space: Opens placement mode with the last placed item."
    .. "\nCtrl-Shift-Space: Opens placement mode with the selected item."
    .. "\nCtrl-Shift-F: Follow Camera (select an object to follow around)."
    .. "\nCtrl-Alt-F: Toggle mouse cursor."
    .. "\nCtrl-Shift-E: Toggle editor mode."
    .. "\n\nFor more info see: https://github.com/ChoGGi/SurvivingMars_CheatMods (or browse the lua files)",
  "tags", "Cheats",
  "image","CheatMenu.png",
  "id", "ChoGGi_CheatMenu",
  --"steam_id","",
	"author", "ChoGGi (thanks to chippydip, therealshibe, BoehserOnkel, Fling)",
	"version", 2.1,
  --"lua_revision","",
	"code", {
		"Init.lua",
	},
  --"loctables","",
  --"saved","",
})