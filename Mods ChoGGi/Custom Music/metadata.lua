return PlaceObj("ModDef", {
	"title", "Custom Music v0.3",
	"version", 3,
  "saved", 1541160000,
	"image", "Preview.png",
	"tags", "Music",
	"id", "ChoGGi_CustomMusic",
	"author", "ChoGGi",
  "steam_id", "1411106409",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Script.lua"
	},
	"description", string.format([[Place files in %s
%%AppData%%\Surviving Mars\Music

As far as I know it only plays opus and wav
mp3,aac,ogg,flac,aiff = don't work
Spaces and what not in names are a-ok.]],ConvertToOSPath("AppData/Music")),
})