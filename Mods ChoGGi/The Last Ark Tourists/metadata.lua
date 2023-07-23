return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 0,
		}),
	},
	"title", "The Last Ark Tourists",
	"id", "ChoGGi_TheLastArkTourists",
	"steam_id", "2539477465",
	"pops_any_uuid", "248720ab-972c-4fb1-9340-84c3882c0d0e",
	"lua_revision", 1007000, -- Picard
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Allows passenger rockets with tourists.
Any non-tourist will be shunted into space and come down as a human shaped meteor (in a few Sols).


Requested by Tremualin and sorta requested by gottalikemilk (probly Apex Akolos too)
]],
})
