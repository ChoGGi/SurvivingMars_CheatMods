return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 3,
		}),
	},
	"title", "Defence Towers Attack Dust Devils",
	"id", "ChoGGi_DefenceTowersAttackDustDevils",
	"steam_id", "1504597628",
	"pops_any_uuid", "957bd9ec-fb96-4c00-9065-984aae313e1f",
	"lua_revision", 1007000, -- Picard
	"version", 8,
	"version_major", 0,
	"version_minor", 8,
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"image", "Preview.jpg",
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Defence Turrets will attack Dust Devils.


Mod Options:
Unlock Tech Defence Turret: Start with towers unlocked (needed unless playing mystery that unlocks them).
Ignore Meteors: Turn on to have towers ignore meteors.


Requested by: rdr99 and Emmote
https://steamcommunity.com/app/464920/discussions/0/2828702373008348129/
]],
})

