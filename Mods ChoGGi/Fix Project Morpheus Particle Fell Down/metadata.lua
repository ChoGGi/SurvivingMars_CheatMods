return PlaceObj("ModDef", {
	"title", "Fix Project Morpheus Particle Fell Down",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"id", "ChoGGi_FixProjectMorpheusParticleFellDown",
	"steam_id", "1576281619",
	"pops_any_uuid", "fed5b2b8-b74e-4e10-b2f1-190ad5c8b6ba",
	"author", "ChoGGi",
	"lua_revision", 1001569,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[This one has been in since release...

On load, and once a day it'll check if the blue growing thing has fallen off any morph towers, and re-attach if any have.

Includes mod option to disable fix.
]],
})
