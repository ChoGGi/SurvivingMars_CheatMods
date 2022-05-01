return PlaceObj("ModDef", {
	"title", "Game Rules Threats Resources",
	"id", "ChoGGi_GameRulesThreatsResources",
	"steam_id", "1801868910",
	"pops_any_uuid", "37ca563c-dfce-4f56-8d5b-9298a092eb8b",
	"lua_revision", 1007000, -- Picard
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagGameplay", true,
	"description", [[
Adds new game rules.

Low Resources:
Resources will always be the lowest level.
Max Threats:
Disasters will always be the highest level (excluding Dust Devils/Active Plate Tectonics).

These don't change the challenge rating/resource display.


NEW GAMES ONLY.
]],
})
