return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 9,
		}),
	},
	"title", "Services Show Comfort Boost",
	"id", "ChoGGi_ServicesShowComfortBoost",
	"lua_revision", 1001514, -- Tito
	"steam_id", "2212802600",
	"pops_any_uuid", "80fc30b4-6e46-4fff-af2a-7f06eaa2e954",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagBuildings", true,
	"TagInterface", true,
	"TagOther", true,
	"description", [[Services only show the "Service Comfort" number, but that's just used as a threshold. It's not the actual comfort received.
This mod adds the "Comfort increase on visit" to the UI (what shows up in the comfort log after a visit).
]],
})
