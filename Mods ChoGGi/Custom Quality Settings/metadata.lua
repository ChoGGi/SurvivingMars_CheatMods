return PlaceObj("ModDef", {
	"title", "Custom Quality Settings",
	"id", "ChoGGi_CustomQualitySettings",
	"steam_id", "2106942055",
	"pops_any_uuid", "4d26f48b-bb04-4859-8947-0bd36e239f8e",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
Allows you to adjust values for settings higher/lower then allowed from in-game options.
Warning! Setting some of these too high can cause crashing; see tooltips.

Settings default to in-game, see mod options to adjust.
You'll likely need to re-apply the mod options if you change the in-game settings.

If you changed enough that it crashes on load, then you can reset settings:
Enable/disable any mod in the mod manager, then you can access mod options in the main menu options.
]],
})
