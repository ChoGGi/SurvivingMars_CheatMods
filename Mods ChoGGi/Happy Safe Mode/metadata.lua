return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 1,
		}),
	},
	"title", "Happy Safe Mode",
	"id", "ChoGGi_HappySafeMode",
	"steam_id", "3292267925",
	"pops_any_uuid", "67f6ad57-7016-458a-853d-d74ead54aeb6",
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
	"TagGameplay", true,
	"description", [[
This removes the chance of suicide (New Ark basically) by giving colonists the Religious trait when Sanity hits 0.

Includes mod option to disable suicides from Story Bits (default enabled).
Also mod options to control Sanity damage.

Requested by termitetechie (a little while ago).
]],
})
