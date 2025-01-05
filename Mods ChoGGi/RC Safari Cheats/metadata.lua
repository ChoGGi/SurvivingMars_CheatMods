return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 3,
		}),
	},
	"title", "RC Safari Cheats",
	"id", "ChoGGi_RCSafariRouteCheats",
	"steam_id", "2425963097",
	"pops_any_uuid", "5deed936-d551-4dfa-99c8-729d5f6e85c1",
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
	"TagGameplay", true,
	"description", [[
Vroom vroom


Mod Options:
Max Safari Length: Change the max safari route limit.
RC Safari Max Waypoints: How many waypoints a safari can have.
Sight Range: How far the tourists can see sights from the rover.
Max passengers: How many tourists per safari.
Satisfaction/health/sanity change on visit: Add * for visit.
Service Comfort: Comfort threshold for increase.
Comfort increase on visit: How much comfort is added per visit.
]],
})
