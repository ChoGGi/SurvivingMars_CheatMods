return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 6,
		}),
	},
	"title", "Drones Carry Amount",
	"id", "ChoGGi_DronesCarryAmountFix",
	"steam_id", "1411107961",
	"pops_any_uuid", "f89fcb61-6a9b-494a-852f-aa37b68dafcc",
	"lua_revision", 1007000, -- Picard
	"version", 13,
	"version_major", 1,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Drones normally only pick up resources from buildings when the amount stored is equal or greater to their carry amount.
Example: if there's 1 res cube and you have the 2x carry upgrade they'll wait for another res cube before picking up.
This mod forces them to pick up whenever there's at least 1 res cube.

Includes mod option to choose the amount to carry.
]],
})
