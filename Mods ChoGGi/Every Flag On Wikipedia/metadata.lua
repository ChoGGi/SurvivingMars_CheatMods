return PlaceObj("ModDef", {
	"title", "Every Flag On Wikipedia",
	"version", 9,
	"version_major", 0,
	"version_minor", 9,
	"id", "ChoGGi_EveryFlagOnWikipedia",
	"author", "ChoGGi",
	"image", "Preview.png",
	"steam_id", "1455937967",
	"pops_any_uuid", "72c38c74-3abc-4248-a29a-9209efbe94f3",
	"lua_revision", 1001569,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Adds every flag on Wikipedia (450+), and no more Martian only names.

Since this game uses nations for names, this also takes all the in-game names and applies them to all the new nations.

This also sets const.FullTransitionToMarsNames to 99999 (Sols), and adds all the names to Mars (I think we've all seen enough of Cosmo Cosmos).

Mod Options:
If you want Martians to have martian names: Randomise Birthplace = false
If you want existing nations to use random names: Default Nation Names = false

Unique names are available in my More Names mod.

If you have a list of names you'd like to add; please format them like these: https://github.com/HaemimontGames/SurvivingMars/blob/master/Lua/Names.lua#L1009



Known Issues:
<image> tags don't like spaces in the path (no flag icon).]],
})
