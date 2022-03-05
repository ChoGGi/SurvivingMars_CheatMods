return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 0,
		}),
	},
	"title", "Farm Cheats",
	"id", "ChoGGi_FarmCheats",
	"steam_id", "2426931293",
	"pops_any_uuid", "204e9e89-25af-44e3-a6f2-8b9c824d92e5",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagCrops", true,
	"description", [[
Adds button to quickly finish growing current crop, as well as mod options to reduce failure/improve yields.

Mod Options:
Crops Never Fail: Crops will never fail no matter the conditions (you'll get a random yield amount instead of failing).
Constant Soil Quality: Soil quality will always be this amount (0 to disable).
Mech Farming: Workers not needed.
Mech Performance: How much performance each farm does without fleshbags.

Applying mod options will toggle working state on farms, crops might fail?
]],
})
