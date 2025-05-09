return PlaceObj("ModDef", {
	"title", "Fix Remove Invalid Label Buildings",
	"id", "ChoGGi_FixRemoveInvalidLabelBuildings",
	"steam_id", "1575894376",
	"pops_any_uuid", "a6fb997b-f9a3-4e61-ac93-0173f9c43d71",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"author", "ChoGGi",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
Labels are a place where the game stores buildings and whatnot.
I came across a non-modded 700 Sol+ game (thanks marklion29) that had some invalid buildings in the labels.
This won't remove any buildings, just the reference in the label list (invalid meaning it isn't an actual obj, so nothing to remove).

I don't know if this will "help" anything, but it won't hurt...

Includes mod option to disable fix.
]],
})
