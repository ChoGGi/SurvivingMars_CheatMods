return PlaceObj("ModDef", {
	"title", "Centred HUD v0.1",
	"version", 1,
	"saved", 1545048000,
	"image", "Preview.png",
	"id", "ChoGGi_CentredHUD",
	"steam_id", "1594140397",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 243725,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Centres HUD for ultrawide resolutions.

This adds a button to the HUD (bottom right), to test/save/clear a saved margin.
When you find one that works for your resolution then please send me your res width and margin, so I can add it to the mod.

Options in HUD button:
Test Margin: Enter a margin value without it being saved (right-click button to open directly).
Save Margin: Same as test, but also saves it (use 0 to never have any margin).
Clear Saved Setting: Removes saved setting (this will still check mod margin setting next time).
Use Mod Setting: Tries to use mod margin setting (also happens when game is started, saved setting overrides).


Currently included settings:
5760x1080 (48:9): 2560



Known Issues:
This only works with the lowest UI Scale.
This just fixes the in-game HUD, I didn't bother with anything else.
Some stuff isn't centred: blue pause overlay, console, console log, and cheat menu.]],
})
