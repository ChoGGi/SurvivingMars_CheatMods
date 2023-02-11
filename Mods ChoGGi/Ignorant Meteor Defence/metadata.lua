return PlaceObj("ModDef", {
	"title", "Ignorant Meteor Defence",
	"id", "ChoGGi_MeteorDefenceIgnoresAnomalies",
	"steam_id", "2438415420",
	"pops_any_uuid", "fb227e70-2835-4b02-a203-56bd61d78c9b",
	"lua_revision", 1007000, -- Picard
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
MDS Lasers and Defensive Turrets won't shoot down meteors with anomalies or other resources in them.

Includes mod option to temp disable if one is going to hit a bad spot.
Mod Options: Ignore Anomalies, Ignore Metals, Ignore Polymers
Ignore No Buildings: Meteors that land away from buildings are ignored (units are a dice roll, still attacks empty meteors).


Not exactly requested by TheMegaMario.
]],
})
