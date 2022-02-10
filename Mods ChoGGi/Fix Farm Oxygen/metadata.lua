return PlaceObj("ModDef", {
	"title", "Fix Farm Oxygen",
	"id", "ChoGGi_FixFarmOxygen",
	"steam_id", "2746801749",
	"pops_any_uuid", "890d6619-9f40-4f71-bf90-1e7c39d67ead",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
If you remove a farm that has an oxygen producing crop (workers not needed) the oxygen will still count in the dome.
This will also update existing domes.

I didn't fix it for demolished, but not removed farms. Those could have plants growing in the ruins ;)


Found thanks to Lepurrcone.
https://forum.paradoxplaza.com/forum/threads/surviving-mars-remove-oxygen-consumption-in-domes-permanently.1509392/
]],
})
