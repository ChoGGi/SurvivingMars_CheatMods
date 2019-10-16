return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 5,
		}),
	},
	"title", "RC Miner",
	"version", 23,
	"version_major", 2,
	"version_minor", 3,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_PortableMiner",
	"author", "ChoGGi",
	"steam_id", "1411113412",
	"pops_any_uuid", "831c4ed8-d892-4815-bb77-3a028c3ea5b0",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[It's a rover that mines, tell it where to go and if there's a resource (Metals/Concrete) close by it'll start mining it.
Supports the Auto-mode added in Sagan (boosts the amount stored per stockpile when enabled).
Use mod options to tweak the settings.



Affectionately known as the pooper shooter.]],
})
