return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 8,
		}),
	},
--~ 	"title", "Stop Current Disasters v0.4",
	"title", "Stop Current Disasters",
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"saved", 0,
	"id", "ChoGGi_StopCurrentDisasters",
	"author", "ChoGGi",
	"steam_id", "1411115645",
	"pops_any_uuid", "a5c6f132-f1f9-4e98-b637-a180732cb923",
	"code", {
		"Code/Script.lua"
	},
	"image", "Preview.png",
	"lua_revision", 245618,
	"description", [[Stops any running disasters (duststorms, coldwaves, and current meteors/dustdevil) when you load a save (you don't need to leave it enabled afterwards).



Included in Expanded Cheat Menu.]],
})
