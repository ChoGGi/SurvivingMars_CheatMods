return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 4,
		}),
	},
	"title", "Add 5 Times The Resource To Deposits",
	"id", "ChoGGi_Add5TimesTheResourceToDeposits",
	"pops_any_uuid", "6ff9709d-3a3b-48b5-be2f-ce3216aa5699",
	"steam_id", "1427609324",
	"lua_revision", 1007000, -- Picard
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua"
	},
	"has_options", true,
	"description", [[
Adds a button to water/metal/concrete deposits to multiply the amount of all deposits of the same resource by 5.

Mod Options:
All Deposits: Update all deposits of the same type.
Multiply Amount: How much to multiply resource amounts by, if set to 0 then this will set amount to 1 (for removing deposit).
Set Grade: Set to 0 to leave grade alone (otherwise 1-6).


Requested by Peacemaker.
]],
})