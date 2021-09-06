return PlaceObj("ModDef", {
	"title", "Renegade Progress",
	"id", "ChoGGi_RenegadeProgress",
	"steam_id", "1802131001",
	"pops_any_uuid", "ce2f0465-bec8-48d1-acab-9656b9c5907e",
	"lua_revision", 1007000, -- Picard
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagInterface", true,
	"has_options", true,
	"description", [[Add renegade progress (and count) to the morale section tooltip of each dome.
Right-clicking the Infobar>Jobs button will cycle between domes brewing renegades.


Mod Options:
Disable Renegades (default disabled):
Anyone that gets the renegade trait will have it removed (does nothing for existing ones).]],
})
