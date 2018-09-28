return PlaceObj("ModDef", {
	"title", "ChoGGi's Library v1.5",
	"version", 15,
	"saved", 1538136000,
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
	"code", {
		-- build the ChoGGi object
		"Init.lua",
		-- gets the font (if not eng lang), and builds a table of translated strings
		"Code/Strings.lua",
		-- common functions
		"Code/CommonFunctions.lua",
		-- defaults,consts
		"Code/Settings.lua",
		-- more like in-game functions?
		"Code/GameFunctions.lua",
		-- for OnMsg functions
		"Code/OnMsgs.lua",

		-- custom dialogs
		"Code/_Classes.lua",
		"Code/ListChoice.lua",
		"Code/MultiLineText.lua",

		-- only needed for mods i have yet to update.
		"LibraryLoaded.lua",
	},
	-- yeah this is getting removed... come on devs allow users to override and deal with outdated mods if they want to (just print it in the log).
	"lua_revision", LuaRevision,

	"description", [[Contains stuff needed by most of my mods.

Getting tired of the copy n paste updating.

Also available at https://www.nexusmods.com/survivingmars/mods/89]],
})
