return PlaceObj("ModDef", {
	"title", "Trade Pad All Resources",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_TradePadAllResources",
	"steam_id", "1800541765",
	"pops_any_uuid", "261454b9-a7a6-4676-a931-beee1710bcd0",
	"author", "ChoGGi",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"TagCrops", true,
	"description", [[Can trade almost all resources (skipped blackcubes/mystery) on the trade pads.
Any res not shown on the planetary view isn't included in the colony so I calculate it from existing resources.

Prices:
PreciousMetals: Electronics * 2
WasteRock: Concrete / 16
Fuel: Polymers / 2

Includes mod option to skip waste rock since it's pretty cheesy.


Known Issues:
I'm too lazy to make icons for them, so I used what's around.]],
})
