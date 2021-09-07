return PlaceObj("ModDef", {
	"title", "Allow Buildings",
	"id", "ChoGGi_AllowBuildings",
	"steam_id", "2595725610",
	"pops_any_uuid", "72724cbe-731f-4edd-b7bb-fcabaa1b10ec",
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
Allow buildings blocked on asteroids/underground to be built.


Added so far:
Tribbys, Rovers, Shuttle Hub, Stirlings, Landscape Flatten (careful could cause issues).
]],
})
