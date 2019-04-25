return PlaceObj("ModDef", {
	"title", "Example New Res Icons",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"saved", 1545220800,
	"image", "Preview.png",
	"id", "ChoGGi_ExampleNewResIcons",
	"steam_id", "1581373413",
	"author", "ChoGGi & Rusty",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Add Entities.lua",
		"Code/Replace Object Entities.lua",
		"Code/Paintbrush.lua",
	},
	"description", [[Replaces the Concrete and Metal resource icons.
Includes instructions for image files to entity files.
Also adds selection panel paintbrush to switch between old and new.

https://github.com/ChoGGi/SurvivingMars_CheatMods/tree/master/Mods%20ChoGGi/Example%20New%20Res%20Icon

A huge thank you to Rusty for the annoying .mtl file futzing around.
A smaller huge thank you to LukeH for the darkness issue.]],
})
