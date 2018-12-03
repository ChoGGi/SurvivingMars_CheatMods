return PlaceObj("ModDef", {
	"title", "Example New Res Icon v0.1",
	"version", 1,
	"saved", 1543492800,
	"image", "Preview.png",
	"id", "ChoGGi_ExampleNewResIcon",
--~ 	"steam_id", "000000000",
	"author", "ChoGGi & Rusty",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Replaces the Concrete and Metal resource icons.
Includes instructions for image files to entity files.

Known Issues:
The textures will be darkened till you zoom in (once the shader is loaded it's fine till you quit the game).
if anyone can figure out a way around... That'd be nice to know.

A huge thank you to Rusty for the annoying .mtl file futzing around.]],
})
