return PlaceObj("ModDef", {
	"title", "Constant Disasters",
	"id", "ChoGGi_ConstantDisasters",
	"steam_id", "1790983059",
	"pops_any_uuid", "5be5be41-e9ef-4a8a-82cc-fbf39b646d10",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagOther", true,
	"description", [[
Set a minimum interval between disasters (if you want hourly toxic rains for some reason).

This is "separate" from the regular disaster happenings, so turning off all the options won't disable regularly scheduled disasters.
It won't screw you over and double up the same disaster.

Mod Options:
Set all disasters, and the time between (max is 600 hours = 25 Sols, more/less?).


Kinda requested by Paladinboyd.
]],
})
