return PlaceObj("ModDef", {
	"title", "Fix Tourist Overview Softlock",
	"id", "ChoGGi_FixSoftlockHotfix3",
	"steam_id", "2434359529",
	"pops_any_uuid", "2dffb277-a8f8-438b-b9a8-aa78da0333f9",
	"lua_revision", 1001514, -- Tito
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[Fix the softlock from Tourism Update- Hotfix 3.


customSupplyRocket.lua > "OnPressParam", "UIOpenTouristOverview",

SupplyRocket.lua > SupplyRocket:UIOpenTouristOverview(reward_info)
instead of getting the reward_info table it gets 1


Compatible with Automated Tourism
]],
})
