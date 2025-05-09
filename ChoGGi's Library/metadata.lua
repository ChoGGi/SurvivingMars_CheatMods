return PlaceObj("ModDef", {
	"title", "<color 135 212 155>ChoGGi's Library</color> Test",
	"id", "ChoGGi_Library",
	"steam_id", "1504386374",
	"pops_any_uuid", "bbeae1a3-fa60-48d3-8bf4-bbfe7d5e018b",
	"pops_desktop_uuid", "36c014ce-1fcd-4cef-9621-a4bd631d3ee0",
	"lua_revision", 1007000, -- Picard
--~ 	"lua_revision", 233360, -- JA3
	"version", 127,
	"version_major", 12,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"last_changes", "https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/ChoGGi's%20Library/Changelog.md#library-changelog",
	"TagInterface", true,
	"TagTools", true,
	"TagOther", true,
	"has_options", true,
	"ignore_files", {
		"*.bat",
		"*.ini",
		".gitignore",
		"Locales/*.ahk",
		"Locales/*.lua",
	},
	"code", {
		-- build the ChoGGi object
		"Code/Init.lua",
		-- gets the font (if not eng lang), and builds a table of translated strings
		"Code/Strings.lua",
		-- functions used in a couple places
		"Code/CommonFunctions.lua",
		-- defaults, consts
		"Code/Settings.lua",
		-- for OnMsg functions
		"Code/OnMsgs.lua",
		-- added/replaced functions
		"Code/Functions.lua",
		-- https://github.com/xolox/lua-lxsh
		"Code/LXSH.lua",
		-- CSV export funcs
		"Code/CSV.lua",

		"Code/Classes_Objects.lua",
		-- custom dialogs
		"Code/Classes_UI.lua",
		-- gagarin is all about styles it seems... kinda annoying having to define a style just to change colour
		"Code/TextStyles_UI.lua",
		-- some dialogs i use
		"Code/Dialogs/ListChoice.lua",
		"Code/Dialogs/MultiLineText.lua",
		-- examine (and dialogs for it)
		"Code/Dialogs/Examine.lua",
		"Code/Dialogs/FindValue.lua",
		"Code/Dialogs/ImageViewer.lua",
		"Code/Dialogs/ExecCode.lua",
		"Code/Dialogs/ObjectEditor.lua",
		-- Mod Options
		"Code/ModOptions.lua",
	},
	"description", [[
Contains stuff needed by some of my mods: Mod options, UI elements, and other stuff (functions lots of functions).

[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2835850170]Mod disabled by content restrictions[/url]

Translation(s):
Chinese (Simplified) by aiawar.

Modders: You can use OpenExamine(obj) in your mods if you need to do some debugging and this mod is installed.

Also available at:
https://www.nexusmods.com/survivingmars/mods/89?tab=files
https://steamcommunity.com/workshop/filedetails/?id=1504386374
https://mods.paradoxplaza.com/mods/7528/Any
https://github.com/ChoGGi/SurvivingMars_CheatMods
]],
})
