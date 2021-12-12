return PlaceObj("ModDef", {
	"title", "Fix No Max Disasters And Mods",
	"id", "ChoGGi_FixNoMaxDisastersAndMods",
	"steam_id", "2680755152",
	"pops_any_uuid", "af99a4d5-6c2b-43cf-9155-3472430c853d",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
Starting a game with any mod and max disaster rules? causes the disasters to default to default?
This restarts disaster threads to use max rule threat levels (dependant on rules).


Requested by... quite a few people.
]],
})
