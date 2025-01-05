return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 3,
		}),
	},
	"title", "Recon Center Change Cost",
	"id", "ChoGGi_ReconCenterChangeCost",
	"steam_id", "2925662527",
	"pops_any_uuid", "aa62c893-d550-458f-8d72-8862fcd14540",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Change cost (and storage) of the Recon Center scanning (see mod options to change).
You'll need to rebuild for the storage size, but the cost is immediate.


Requested by Zoi.
]],
})
