return PlaceObj("ModDef", {
	"title", "Example Translation Mod",
	"id", "ChoGGi_ExampleTranslationMod",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
Example of a mod you can use to translate strings.
You could also use loc tables in the mod editor.

This doesn't work for my ECM mod (yet), for that you'll need to send me a CSV file (see SChinese.csv on my git).
]],
})
