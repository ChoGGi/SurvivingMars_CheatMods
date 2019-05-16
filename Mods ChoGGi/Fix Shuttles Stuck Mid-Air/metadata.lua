return PlaceObj("ModDef", {
	"title", "Fix: Shuttles Stuck Mid-Air",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"saved", 1540641600,
	"image", "Preview.png",
	"id", "ChoGGi_FixShuttlesStuckMidAir",
	"steam_id", "1549680063",
	"author", "ChoGGi",
	"lua_revision", 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[If you've got any shuttles stuck mid-air...
This only checks for them on load, if it's a common occurrence for you then send me a msg.

This waits in between sending each one home, else they may just get stuck again...
If it's been over a minute then upload your save file somewhere, so I can take a look-see.

You can disable/remove it afterwards (or at least till the next time it happens).]],
})
