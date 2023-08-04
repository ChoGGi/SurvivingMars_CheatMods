return PlaceObj("ModDef", {
	"title", "Disable Story Bits",
	"id", "ChoGGi_DisableStoryBits",
	"steam_id", "2556338651",
	"pops_any_uuid", "2b7ca71b-edf8-43b2-97a9-1d103a07440d",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Disable certain annoying storybits.

Mod Options:
Fickle Economics: The import price of <name> will be increased by <price_increase>% in <sols(delay)> Sols.
Rocket Malfunction: Our <DisplayName> Rocket seems to have suffered a malfunction in her fuel tank.
Grudge: Our experts have begun fixing the data block as we speak. However, preliminary analysis of the problem suggests it is sabotage from our rivals here on Mars.


This won't change anything if the storybit is already activated.
]],
})
