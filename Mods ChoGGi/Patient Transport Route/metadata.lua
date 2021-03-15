return PlaceObj("ModDef", {
	"title", "Patient Transport Route",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.png",
	"id", "ChoGGi_PatientTransportRoute",
	"steam_id", "1549495949",
	"pops_any_uuid", "0f27c2bc-c79e-451f-8269-1562b6abf699",
	"author", "ChoGGi",
	"lua_revision", 1001514,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Transports will no longer remove a route just because the supply area is empty of resources.
Instead they'll just sit by the pickup area till more shows up (same for drop off).

Use mod options to change minimum resource to wait for (default 10).
]],
})
