return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 3,
		}),
	},
	"title", "Colonist Change Time New Place",
	"id", "ChoGGi_ColonistCheats",
	"steam_id", "2624207331",
	"pops_any_uuid", "e4938b5d-74e4-4b2b-8bfc-5b7875d32dde",
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
	"TagGameplay", true,
	"description", [[
When you manually move a colonist to a new Workplace, Residence, Dome it defaults to forcing them there for 5 Sols.
Use mod option to increase that time (if changed mid-game only applies to newly moved).
]],
})
