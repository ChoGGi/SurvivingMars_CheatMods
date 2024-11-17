return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 3,
		}),
	},
	"title", "RC Tanker",
	"id", "ChoGGi_RCTanker",
	"steam_id", "1653353483",
	"pops_any_uuid", "aaa0130c-0757-4938-8b57-0d5cded4e892",
	"lua_revision", 1007000, -- Picard
	"version", 14,
	"version_major", 1,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Allows you to drain an oxygen or water tank then use it to fill another tank.
It works with elevators/lander rockets.

Adds two buttons to the selection panel: One to switch between draining and filling, and one to switch between oxygen/water (will empty tank of current resource).
By default it can hold an unlimited amount, includes a mod option to limit it to X units (if you feel it's too cheap).

Depending on DLC installed RC and tank will use different models.
]],
})
