return PlaceObj("ModDef", {
	"title", "Example Colour Scheme",
	"version", 20,
	"version_major", 0,
	"version_minor", 1,
	"saved", 1542283200,
	"image", "Preview.png",
	"id", "ChoGGi_CustomColourScheme",
	"steam_id", "1565748234",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"TagCosmetics", true,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Example of a custom colour scheme (Command center>building colours).
There is a ModItem version of this, but it isn't in the mod editor for some reason?

This is a copy n paste of an in-game scheme (it's for modders that want to make their own).

If you use Expanded Cheat Menu, you can use the built-in editor (Menu>Debug>Ged Presets Editor>ColonyColorScheme).
It won't actually save anything to file, but you can access the edited scheme in the console with ~ColonyColorSchemes.

Manually convert the numbers with ColorizationMaterialDecode(NUMBER), this will return three numbers:
a value you can use with GetRGB(value), roughness value, metallic value
to convert back into the proper number use ColorizationMaterialEncode(RGB(22,36,50), rough, met)
You can use my Change Object Colour mod to test out the values.

Direct download: https://github.com/ChoGGi/SurvivingMars_CheatMods/tree/master/Mods%20ChoGGi/Example%20Colour%20Scheme
Built-in ones: https://github.com/HaemimontGames/SurvivingMars/blob/master/Data/ColonyColorScheme.lua]],
})
