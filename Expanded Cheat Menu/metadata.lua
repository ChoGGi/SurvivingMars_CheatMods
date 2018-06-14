return PlaceObj("ModDef", {
	"title", "Cheat Menu Expanded v5.4",
	"version", 54,
	"saved", 1528891200,
	"description", [[Enables the game's built-in cheat tools, as well as adding a crapload of custom menu settings, I also re-added the Examine Object tool.
There's a cheats section in most info panels on the right side of the screen.
F2: Toggle the cheats menu (Ctrl-F2 to toggle cheats section).
F3: Set object opacity.
F4: Open object examiner.
F5: Open object manipulator (or use edit button in examiner).
F6: Change object colours.
F7: Toggle using last building orientation.
F9: Clear the console log.
Ctrl+F: Fills object resource storage.
Enter or Tilde: Show the console.
Number keys: Toggle build menu (Shift-*Num for menus above 10).
Ctrl-Alt-Shift-R: Opens console and places "restart" in it.
Ctrl-Space: Opens placement mode with the last placed object.
Ctrl-Shift-Space: Opens placement mode with selected object (works with deposits).
Ctrl-Shift-F: Follow Camera (follows an object around).
Ctrl-Alt-F: Toggle mouse cursor (useful in follow mode to select stuff).
Ctrl-Shift-E: Toggle editor mode.
Ctrl-Alt-Shift-D: Delete object.
Shift-Q: Clone selected object to mouse position.
Ctrl-Numpad . 2 3 enable gametime pathing markers on selected object, use Ctrl-Numpad 0 to remove.

object = either the selected object or the object under the mouse cursor."

For more info and source code see: https://github.com/ChoGGi/SurvivingMars_CheatMods.]],
	"image", "CheatMenu.png",
	"id", "ChoGGi_CheatMenu",
	"author", [[ChoGGi
With thanks to chippydip, admbraden, SkiRich, BoehserOnkel, and Fling.
Random internet users reporting bugs/requesting features.]],
  "steam_id", 76561198018190236,
	"code", {"Init.lua"},
	"TagGameplay", true,
	"TagInterface", true,
	"TagTools", true,
	"TagOther", true,
	"TagCheats", true,
})
