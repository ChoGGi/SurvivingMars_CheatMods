return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 6,
		}),
	},
	"title", "Save Mission Profiles",
	"id", "ChoGGi_SaveMissionProfiles",
	"steam_id", "1667138652",
	"pops_desktop_uuid", "9be35386-0eb9-4093-ab4d-1ae85c1e4e18",
	"lua_revision", 1007000, -- Picard
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"description", [[
Adds a "Profiles" button to the new game toolbar button area.
Profile contains: Sponsor, Commander, Logo, Mystery, Rivals, Game Rules, Cargo, and Landing Spot.

Known Issues: You have to change the "page" before settings are visually updated (probably figure it out next update).
]],
})
