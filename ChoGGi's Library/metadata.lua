return PlaceObj("ModDef", {
	"title", "ChoGGi's Library v5.0 Test",
	"version", 50,
	"saved", 1545566400,
	"image", "Preview.png",
	"id", "ChoGGi_Library",
	"steam_id", "1504386374",
	"author", "ChoGGi",
	"TagGameplay", true,
	"TagInterface", true,
	"TagTools", true,
	"TagOther", true,
	"TagCheats", true,
	"last_changes", "https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/ChoGGi's%20Library/Changelog.md#library-changelog",
	"lua_revision", LuaRevision,
	"code", {
		-- build the ChoGGi object
		"Code/Init.lua",
		-- gets the font (if not eng lang), and builds a table of translated strings
		"Code/Strings.lua",
		-- functions used in a couple places
		"Code/CommonFunctions.lua",
		-- defaults,consts
		"Code/Settings.lua",
		-- for OnMsg functions
		"Code/OnMsgs.lua",
		-- LXSH: https://github.com/xolox/lua-lxsh
		"Code/LXSH.lua",

		"Code/Classes_Objects.lua",
		-- custom dialogs
		"Code/Classes_UI.lua",
		-- gagarin is all about styles it seems... kinda annoying having to define a style just to change colour
		"Code/TextStyles_UI.lua",
		-- some dialogs i use
		"Code/ListChoice.lua",
		"Code/MultiLineText.lua",
	},
	"description", [[Contains stuff needed by most of my mods.
The load order for my library in relation to my mods isn't an issue.

Reason for this mod:
I got tired of copying and pasting functions between different mods to update them, now I just update this mod for those functions.



Also available at https://www.nexusmods.com/survivingmars/mods/89]],
})
