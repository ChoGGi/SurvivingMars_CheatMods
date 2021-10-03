return PlaceObj("ModDef", {
	"title", "Specialist By Experience",
	"id", "ChoGGi_SpecialistByExperience",
	"steam_id", "1461190633",
	"pops_any_uuid", "16aa5fa7-f019-4772-92a5-7dd977a35322",
	"lua_revision", 1007000, -- Picard
	"version", 11,
	"version_major", 1,
	"version_minor", 1,
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"image", "Preview.png",
	"description", [[
Colonists without a spec that work at the same job for 25 Sols will automagically get the specialisation needed for that workplace.

Mod Options:
Override Existing Spec: If colonist is already a specialist it will be replaced.
Sols To Train: How many Sols of working does it take to get a spec.

Known Issues:
For saved games this obviously doesn't have a count of how long colonists have previously worked (got a feeling I'd be answering this question eventually).


Idea by Dragonmystic.
]],
})
