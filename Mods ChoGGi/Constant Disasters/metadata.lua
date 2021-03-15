return PlaceObj("ModDef", {
	"title", "Constant Disasters",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"id", "ChoGGi_ConstantDisasters",
	"steam_id", "1790983059",
	"pops_any_uuid", "5be5be41-e9ef-4a8a-82cc-fbf39b646d10",
	"author", "ChoGGi",
	"lua_revision", 1001514,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagOther", true,
	"description", [[Set a minimum interval between disasters (if you want hourly toxic rains for some reason).

This is "separate" from the regular disaster happenings, so turning off all the options won't disable regularly scheduled disasters.
To be clear it won't screw you over and double up the same disaster.

Mod Options:
Set all disasters, and the time between (max is 600 hours = 25 Sols, more/less?).


Kinda requested by Paladinboyd.]],
})
