return PlaceObj("ModDef", {
	"title", "Disable Selection Panel Sizing",
	"version_major", 0,
	"version_minor", 3,
	"saved", 1546516800,
	"image", "Preview.png",
	"id", "ChoGGi_DisableSelectionPanelSizing",
	"steam_id", "1573994315",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244124,
	"code", {
		"Code/ModConfig.lua",
		"Code/Script.lua",
	},
	"description", [[In Gagarin update someone thought shrinking the selection panel was a good idea, and now the panel is too scared to use the bottom half of the screen.

Includes Mod Config Reborn option to re-enable sizing (mods add stuff and it can cause the panel to be too big).



Wrapping a scrollbar around idContent is a no-go I guess? I did a mod to do that, works fine other than making the UI flicker when I mouseover the pinned icons :)
https://steamcommunity.com/sharedfiles/filedetails/?id=1613335225]],
})
