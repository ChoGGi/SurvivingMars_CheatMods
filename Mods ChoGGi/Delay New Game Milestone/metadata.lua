return PlaceObj("ModDef", {
	"title", "Delay New Game Milestone",
	"id", "ChoGGi_DelayNewGameMilestone",
	"steam_id", "2492168609",
	"pops_any_uuid", "b02c5380-299f-4ef7-98e4-abb38969cac4",
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
	"TagMissionSponsors", true,
	"TagGameplay", true,
	"TagResearch", true,
	"description", [[
At the start of a new game; any research points from milestones (find water on mars from hydro engineer) will be delayed till Sol 2. This means no more research points wasted on the default tech.


Requested by slipstream1993.
]],
})
