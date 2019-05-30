return PlaceObj("ModDef", {
	"title", "Log Flush",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"saved", 1533297600,
	"id", "ChoGGi_LogFlush",
	"steam_id", "1414089790",
	"pops_any_uuid", "7d2ffef4-855b-400a-9b23-ad5384d979bc",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"image", "Preview.png",
	"lua_revision", 245618,
	"description", [[This calls the FlushLogFile() function as soon as the game loads, as well as each new Sol.
Now if SM crashes a certain way (that doesn't create the log), you still have a log to look at.

Also included are commented out options to flush on NewHour/NewMinute.



Included in Expanded Cheat Menu.]],
})
