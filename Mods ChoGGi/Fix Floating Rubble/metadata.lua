return PlaceObj("ModDef", {
	"title", "Fix Floating Rubble",
	"id", "ChoGGi_FixFloatingRubble",
	"steam_id", "2737345906",
	"pops_any_uuid", "f91d1733-20e1-4eef-943e-51b6b99c62ed",
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
On load move any floating underground rubble to within reach of drones (might have to "push" drones to make them go for it).

You can disable in mod options after first load (though if there's more floating rubble then enable it again).
]],
})
