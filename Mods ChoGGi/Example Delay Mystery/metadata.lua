return PlaceObj("ModDef", {
	"title", "Example Delay Mystery",
	"id", "ChoGGi_ExampleDelayMystery",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"description", [[
Looks for a gamerule id called "replace with gamerule id", if it finds it then the start of the mystery will be delayed 100 days (sols).
]],
})
