return PlaceObj("ModDef", {
	"title", "Custom Music",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"saved", 1541160000,
	"image", "Preview.png",
	"tags", "Music",
	"id", "ChoGGi_CustomMusic",
	"author", "ChoGGi",
	"steam_id", "1411106409",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Place files in %AppData%\Surviving Mars\Music
C:\Users\USERNAME\AppData\Roaming\Surviving Mars\Music (AppData is a hidden folder).


As far as I know it only plays opus and wav
mp3, aac, ogg, flac, aiff = don't work
Spaces and what not in names are a-ok.]],
})