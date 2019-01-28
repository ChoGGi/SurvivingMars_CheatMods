return PlaceObj("ModDef", {
	"title", "ChoGGi's Library v5.3 Test",
	"version", 53,
	"saved", 1548676800,
	"image", "Preview.png",
	"id", "ChoGGi_Library",
	"author", "ChoGGi",
	"steam_id", "1504386374",
	"pops_any_uuid", "d8b39692-93b4-4446-9149-2e1addd28ac4",
	"last_changes", "https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/ChoGGi's%20Library/Changelog.md#library-changelog",
	"lua_revision", LuaRevision,
	"saved_with_revision", LuaRevision,
	"TagGameplay", true,
	"TagInterface", true,
	"TagTools", true,
	"TagOther", true,
	"TagCheats", true,
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
