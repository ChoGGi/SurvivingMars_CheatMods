return PlaceObj("ModDef", {
	"title", "Custom Red Frontier Music",
	"id", "ChoGGi_CustomRedFrontierMusic",
	"steam_id", "3465746029",
	"pops_any_uuid", "3eb8756a-996f-4f3c-a4e7-a29df3ccb472",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagRadio", true,
	"description", [[
Add a way to add new songs (and blurbs/commericals/etc) to Red Frontier station.
You may need to "pick" the station again to update songs.


To add audio place them in:
%AppData%\Surviving Mars\Music
C:\Users\[b][i]USERNAME[/i][/b]\AppData\Roaming\Surviving Mars\Music (AppData is a hidden folder).

Spaces and what not in music names are a-ok.

[b]Supported types[/b]: opus, wav
[b]NOT working[/b]: mp3, aac, ogg, flac, aiff

Requested by Willafast.
]],
})
