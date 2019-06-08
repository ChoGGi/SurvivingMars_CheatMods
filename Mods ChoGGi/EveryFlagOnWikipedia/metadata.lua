return PlaceObj("ModDef", {
--~ 	"title", "Every Flag On Wikipedia v0.6",
	"title", "Every Flag On Wikipedia",
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"saved", 0,
	"id", "ChoGGi_EveryFlagOnWikipedia",
	"author", "ChoGGi",
	"image", "Preview.png",
	"steam_id", "1455937967",
	"pops_any_uuid", "72c38c74-3abc-4248-a29a-9209efbe94f3",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Adds every flag on Wikipedia (450+), and no more Martian only names.

Since this game uses nations for names, this also takes all the in-game names and applies them to all the new nations.

This also sets const.FullTransitionToMarsNames to 9999 (Sols), and adds all the names to Mars (I think we've all seen enough of Cosmo Cosmos).

mod options:
If you want Martians to have martian names: Randomise Birthplace = false
If you want existing nations to use random names: Default Nation Names = false

I also added a few unique names associated with space.
Suggestions welcome, for names already added see: https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/Mods%20ChoGGi/EveryFlagOnWikipedia/Code/Script.lua#L180
^ New game needed to see uniques.

If you have a list of names you'd like to add:
Male given
Female given
Family (separate male/female family names are doable)

Please format them like in Script.lua.]],
})
