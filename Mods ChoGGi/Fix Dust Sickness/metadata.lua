return PlaceObj("ModDef", {
	"title", "Fix Dust Sickness",
	"id", "ChoGGi_FixDustSickness",
	"steam_id", "2971469972",
	"pops_any_uuid", "f69f130c-6697-4101-bfab-30737a1431ae",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
There's a storybit that will give Biorobots (and other colonists) dust sickness.
It may not remove it from the colonists, and since Biorobots live forever then they have it forever.

This will remove the dust sickness trait from anyone that has it, use the mod option to disable it after loading your save.


Requested by aom17.
]],
})
