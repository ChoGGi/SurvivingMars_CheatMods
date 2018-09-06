return PlaceObj("ModDef", {
	"title", "ChoGGi's Library v0.4",
	"version", 4,
	"saved", 1536148800,
	"image", "Preview.png",
	"id", "ChoGGi_Library",
	"steam_id", "1504386374",
	"author", "ChoGGi",
	"TagGameplay", true,
	"TagInterface", true,
	"TagTools", true,
	"TagOther", true,
	"TagCheats", true,
	"last_changes", "https://github.com/ChoGGi/SurvivingMars_CheatMods/blob/master/ChoGGi%20MenuLibrary/Changelog.md#library-changelog",
	"code", {
		-- build the ChoGGi object
		"Init.lua",
		-- gets the font (if not eng lang), and builds a table of translated strings
		"Code/Strings.lua",
		-- common functions
		"Code/CommonFunctions.lua",
		-- defaults,consts
		"Code/Settings.lua",
		-- any funcs called from Code/*
		"Code/GameFunctions.lua",

		-- custom dialogs
		"Code/Dialogs/_Classes.lua",
		"Code/Dialogs/ListChoice.lua",
		"Code/Dialogs/MultiLineText.lua",

		-- let my mods know we're good to go
		"LibraryLoaded.lua",
	},
	-- yeah this is getting removed... come on devs allow users to override and deal with outdated mods if they want to (just print it in the log).
	"lua_revision", LuaRevision,

	"description", [[Contains stuff needed by most of my mods.

Getting tired of the copy n paste updating.]],
})
