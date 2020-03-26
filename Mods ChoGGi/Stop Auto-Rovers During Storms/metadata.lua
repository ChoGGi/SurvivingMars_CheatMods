return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 9,
		}),
	},
	"title", "Stop Auto-Rovers During Storms",
	"version", 5,
	"version_major", 0,
	"version_minor", 5,

	"image", "Preview.png",
	"id", "ChoGGi_StopAutoRoversDuringStorms",
	"steam_id", "1796377313",
	"pops_any_uuid", "047b4e7f-37d7-4c89-a600-598339e2d955",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[Rovers will not do automated tasks when a meteor storm is active.
They'll finish up whatever task they're on then stop moving till it's over, so you may need to move them out of the way.

Mod Options:
Go to the nearest working laser/missile tower if rover is idle (default on).
Or drone hub (laser option takes precedence).]],
})
