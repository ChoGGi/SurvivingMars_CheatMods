return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 6,
		}),
	},
	"title", "Deep Resources Never Run Out",
	"id", "ChoGGi_DeepResourcesNeverRunOut",
	"steam_id", "1775640697",
	"pops_any_uuid", "a468ea08-8d6f-4e23-99a4-a45b2a3e9ffe",
	"lua_revision", 1007000, -- Picard
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Deep resources amounts are all set to 500k and get refilled every new Sol (also kicks in when a deposit is revealed).

Mod Options:
Do the same for regular underground deposits.
Set grade to very high (less waste rock).
Skip Asteroids: Asteroid deposits don't get filled.

Deposits will be refreshed when you apply mod options (if needed).

Requested by Mephane
https://steamcommunity.com/workshop/discussions/18446744073709551615/3211505894135785138/
]],
})
