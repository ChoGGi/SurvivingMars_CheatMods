return PlaceObj("ModDef", {
	"title", "Game Rules Threats Resources",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,

	"image", "Preview.png",
	"id", "ChoGGi_GameRulesThreatsResources",
	"steam_id", "1801868910",
	"pops_any_uuid", "37ca563c-dfce-4f56-8d5b-9298a092eb8b",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"TagGameplay", true,
	"description", [[Adds new game rules.

Low Resources:
Resources will always be the lowest level.
Max Threats:
Disasters will always be the highest level (excluding Dust Devils).

These don't change the challenge rating/resource display.


NEW GAMES ONLY.]],
})
