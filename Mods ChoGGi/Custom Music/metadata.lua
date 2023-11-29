return PlaceObj("ModDef", {
	"title", "Custom Music",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"id", "ChoGGi_CustomMusic",
	"author", "ChoGGi",
	"steam_id", "1411106409",
	"pops_any_uuid", "8485c765-6701-4ce6-ab46-abc2a33b329f",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
	"description", [[
Place files in:
%AppData%\Surviving Mars\Music
C:\Users\[b][i]USERNAME[/i][/b]\AppData\Roaming\Surviving Mars\Music (AppData is a hidden folder).

Spaces and what not in music names are a-ok.

[b]Supported types[/b]: opus, wav
[b]NOT working[/b]: mp3, aac, ogg, flac, aiff
]],
})