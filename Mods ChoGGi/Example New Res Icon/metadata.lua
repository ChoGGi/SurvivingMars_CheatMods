return PlaceObj("ModDef", {
	"title", "Example New Res Icons",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,

	"image", "Preview.png",
	"id", "ChoGGi_ExampleNewResIcons",
	"steam_id", "1581373413",
	"pops_any_uuid", "e415aa53-69de-49b3-8711-8b6fe51b4d28",
	"author", "ChoGGi & Rusty",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/AddEntities.lua",
		"Code/ReplaceObjectEntities.lua",
		"Code/Paintbrush.lua",
	},
	"description", [[Replaces the Concrete and Metal resource icons.
Includes instructions for image files to entity files.
Also adds selection panel paintbrush to switch between old and new.

https://github.com/ChoGGi/SurvivingMars_CheatMods/tree/master/Mods%20ChoGGi/Example%20New%20Res%20Icon

A huge thank you to Rusty for the annoying .mtl file futzing around.
A smaller huge thank you to LukeH for the darkness issue.]],
})
