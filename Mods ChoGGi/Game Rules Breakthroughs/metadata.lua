return PlaceObj("ModDef", {
	"title", "Game Rules Breakthroughs",
	"id", "ChoGGi_GameRulesBreakthroughs",
	"steam_id", "1753933193",
	"pops_any_uuid", "6729224c-c34e-46fb-9355-400a0cdc5402",
	"lua_revision", 1007000, -- Picard
	"version", 18,
	"version_major", 1,
	"version_minor", 8,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Adds all breakthroughs to game rules (selected rules will be unlocked).

Related mods: [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2324443848]Unlock Breakthroughs[/url]
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=2429688365]Unlock Research Tech[/url]

Mod Options:
Breakthroughs Researched: Research instead of unlock breakthroughs (New game needed after option is applied or maybe restart game).
Sort Breakthrough List: Sort the list of breakthroughs alphabetically (order effects in-game cost), disable for random.
Exclude Breakthroughs: Enabling a rule will stop that breakthrough from appearing (adds a random one instead).


Known Issues:
You need to be in-game to be able to see the mod options.
Exclude Breakthroughs may not always work on breakthrough anomalies scanned by explorers.
]],
})
