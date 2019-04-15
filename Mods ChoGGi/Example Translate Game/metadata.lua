return PlaceObj("ModDef", {
	"title", "Example: Translate Game",
	"version_major", 0,
	"version_minor", 1,
	"saved", 1546344000,
	"image", "Preview.png",
	"id", "ChoGGi_ExampleTranslateGame",
	"steam_id", "1611000844",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[This isn't a complete translation mod, it's an example with a few strings translated (I wouldn't bother subscribing).



This mod will add an option to use "Italian" to Options>Gameplay>Language.
Includes a Game.csv that changes a few strings as an example (showing how to use , and "").
See SM folder\ModsTools\Game.csv for the full list of string ids.

To add a language other than Italian: You'll need to edit the first few lines of Code/Script.lua.

You can also get the mod from: https://github.com/ChoGGi/SurvivingMars_CheatMods/tree/master/Mods%20ChoGGi/Example%20Translate%20Game



If you get one of these errors when trying to load your CSV file:
"[LUA ERROR] table index is nil, field ModsLoadLocTables"
"CommonLua/Core/localization.lua:559: table index is nil"

Install my Expanded Cheat Menu mod then go to Menu>Debug>Test Locale File
It'll return a list of translated and failed strings, as well as some context to where the error is.
]],
})
