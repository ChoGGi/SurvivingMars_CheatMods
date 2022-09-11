return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 6,
		}),
	},
	"title", "RC Driller Cheats",
	"id", "ChoGGi_RCDrillerCheats",
	"steam_id", "2600754488",
	"pops_any_uuid", "33a06b7a-9429-4773-b5a2-7416f53a0649",
	"lua_revision", 1007000, -- Picard
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Adds automated mode support, and mod options.

Mod Options:
Loss Amount: How much is lost when using driller (0 = all, 100 = none).
Production Per Day: Change how much it produces each Sol.
Allow Deep: Can exploit deep deposits.
Remove Sponsor Lock: No need to play as Russia to use it (Rover printing is still needed).
No Waste Rock: No waste rock generated.
]],
})
