return PlaceObj("ModDef", {
	"title", "Mark Deposit Ground",
	"id", "ChoGGi_MarkDepositGround",
	"pops_any_uuid", "3b37cc32-66d0-4233-8366-9038691ebe0e",
	"steam_id", "1555446081",
	"lua_revision", 1007000, -- Picard
	"version", 12,
	"version_major", 1,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Marks the ground around deposits so you can turn off the ugly signs and still see where they are.
Marks are sized depending on max amount.

Mod Options:
Hide Signs: Hide signs on the map (pressing "I" will not toggle them).
Alien Signs: Change anomaly signs to aliens.
Construction Signs: Signs are visible during construction.
Always Show Deposits: Deposit textures will be visible before sector scan.
]],
})
