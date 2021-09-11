return PlaceObj("ModDef", {
	"title", "Fix Expedition RCs",
	"id", "ChoGGi_FixExpeditionRCCommander",
	"steam_id", "2253103829",
	"pops_any_uuid", "094092b1-d496-4242-af9f-c6f21aac4c38",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagOther", true,
	"TagGameplay", true,
	"description", [[
DOES NOT WORK IN PICARD



Expeditions that require an RC will work with faction specific rovers (Seeker, Generator, etc).
You'll need to restart existing expeditions waiting for an RC for this to take effect.

Works for any rover.


Requested by slarpy_Chiuyan.
]],
})
