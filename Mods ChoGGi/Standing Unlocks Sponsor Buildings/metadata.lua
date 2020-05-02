return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 2,
		}),
	},
	"title", "Standing Unlocks Sponsor Buildings",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,

	"image", "Preview.png",
	"id", "ChoGGi_StandingUnlocksSponsorBuildings",
	"steam_id", "1569118695",
	"pops_any_uuid", "118d2bb6-8210-4fda-b0d8-125713fe1ee9",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[If your standing with a rival colony is excellent (min 61), you will be able to build any buildings locked to that sponsor.
This is a slightly less cheaty version of All Sponsor Buildings.
Shows a notification when unlocked buildings have changed (disable in mod options).


Requested by ve2dmn/veryinky.]],
})
