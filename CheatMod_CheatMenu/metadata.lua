return PlaceObj("ModDef", {
	"title", "Cheat Menu Expanded v3.8",
	"version", 38,
	"saved", 1525780800,
	"description", "\nEnables the game's built-in cheat tools, as well as adding a crapload of custom menu settings. "
    .. "There's a cheats section in most info panels on the right side of the screen."
    .. "\n\nF2: Toggle the cheats menu.."
    .. "\nF3: Set object opacity."
    .. "\nF4: Open object examiner."
    .. "\nF5: Open object manipulator (or use edit button in examiner)."
    .. "\nF6: Change object colours."
    .. "\nF7: Toggle using last building orientation."
    .. "\nF9: Clear the console log."
    .. "\nCtrl+F: Fill resource of object."
    .. "\nEnter or Tilde: Show the console."
    .. "\nNumber keys: Toggle build menu (Shift-*Num for menus above 10)."
    .. "\nCtrl-Alt-Shift-R: Opens console and places \"restart\" in it."
    .. "\nCtrl-Space: Opens placement mode with the last placed object."
    .. "\nCtrl-Shift-Space: Opens placement mode with selected object (works with deposits)."
    .. "\nCtrl-Shift-F: Follow Camera (follow an object around)."
    .. "\nCtrl-Alt-F: Toggle mouse cursor (useful in follow mode to select stuff)."
    .. "\nCtrl-Shift-E: Toggle editor mode."
    .. "\nCtrl-Alt-Shift-D: Delete object."
    .. "\nShift-Q: Clone selected object to mouse position."
    .. "\n\nobject = either the selected object or the object under the mouse cursor."
    .. "\n\nFor more info see: https://github.com/ChoGGi/SurvivingMars_CheatMods (or browse the lua files).",
	"image", "CheatMenu.png",
	"id", "ChoGGi_CheatMenu",
	"author", "ChoGGi\nWith thanks to chippydip, BoehserOnkel, Fling, and random internet users reporting bugs/requesting features.",
	"code", {"Init.lua"},
	"TagGameplay", true,
	"TagInterface", true,
	"TagTools", true,
	"TagOther", true,
	"TagCheats", true,
})