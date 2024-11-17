return PlaceObj("ModDef", {
	"title", "Change Other To Random Gender",
	"id", "ChoGGi_ChangeOtherToRandomGender",
	"steam_id", "1541604722",
	"pops_any_uuid", "bccb41f2-3172-48ba-8466-ca113ce458aa",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"description", [[
Community:CalcBirth() only uses Male/Female genders to generate births, Other gender isn't included in the fertility count.
Use this mod to maximize birth rates on higher difficulty maps.

This will change any colonists born/newly landed on Mars with the Other gender to be randomly changed into Male/Female.


Requested by Olaf.
]],
})
