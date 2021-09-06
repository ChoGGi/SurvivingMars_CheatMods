return PlaceObj("ModDef", {
	"title", "Fix Tourism Rockets",
	"id", "ChoGGi_FixTourismRockets",
	"steam_id", "2534236742",
	"pops_any_uuid", "3cdb06e3-8611-430c-b185-ce4e7a815ea5",
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
In the Tourism/Tito update devs changed the SupplyRocket class name to RocketBase, and missed a few references.
This fixes them (mod option to disable when fixed by devs).


https://www.reddit.com/r/SurvivingMars/comments/obb7hx/planetary_expedition_bug_floor_is_lava_and/
https://www.reddit.com/r/SurvivingMars/comments/ocse8b/foreigner_in_a_foreign_land_bug_broken_expedition/
https://forum.paradoxplaza.com/forum/threads/surviving-mars-missed-a-reference-to-supplyrocket.1481634/
]],
})
