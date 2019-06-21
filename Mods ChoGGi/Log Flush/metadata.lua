return PlaceObj("ModDef", {
	"title", "Log Flush",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"saved", 0,
	"id", "ChoGGi_LogFlush",
	"steam_id", "1414089790",
	"pops_any_uuid", "7d2ffef4-855b-400a-9b23-ad5384d979bc",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"image", "Preview.png",
	"lua_revision", 245618,
	"TagTools", true,
	"has_options", true,
	"TagOther", true,
	"description", [[This calls the FlushLogFile() function as soon as the game loads, as well as each new Sol.
Now if SM crashes a certain way (that doesn't create the log), you still have a log to look at (unless you're on Xbox).

Also included are mod options to flush more often (probably shouldn't leave them on normally).

Logs can be found in:
%AppData%\Surviving Mars\logs
C:\Users\USERNAME\AppData\Roaming\Surviving Mars\logs (AppData is a hidden folder)



Included in Expanded Cheat Menu.]],
})
