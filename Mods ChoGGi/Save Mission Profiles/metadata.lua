return PlaceObj("ModDef", {
	"title", "Save Mission Profiles v0.1",
	"version", 1,
	"saved", 1551096000,
	"image", "Preview.png",
	"id", "ChoGGi_SaveMissionProfiles",
	"steam_id", "1667138652",
	"pops_desktop_uuid", "9be35386-0eb9-4093-ab4d-1ae85c1e4e18",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Adds a "Profiles" button to the new game toolbar button area.

Save Profile: Save current mission, cargo, and landing spot settings (will overwrite same name without asking).
Load Profile:	Load saved mission profile.
Delete Profile: Delete saved mission profile.

Known Issues: You have to change the "page" before settings are visually updated (probably figure it out next update).
]],
})
