return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Terraformer v1.4",
	"version", 14,
  "saved", 1554120000,
	"id", "ChoGGi_Terraformer",
	"author", "ChoGGi",
  "code", {
    "Code/Script.lua",
  },
	"TagOther", true,
	"image", "Preview.png",
	"steam_id", "1415296985",
	"lua_revision", LuaRevision or 243725,
	"description", [[Simple guide: https://steamcommunity.com/sharedfiles/filedetails/?id=1530394137

If you're feeling OCD about a perfect layout for your base then look no further.

Press Shift-F to begin, press Shift-F again to update buildable area.
Press Ctrl-Shift-1 to remove large rocks, Ctrl-Shift-2 for small ones (shows a confirmation before).
Ctrl-Shift-Alt-D to delete object under mouse (any object and there's no confirmation).

You can rebind keys with the in-game options (scroll to the bottom).

There's a hard limit on how close to the edge you can build (I'll probably figure that out one of these days), so I wouldn't bother flattening the border mountains.



Included in Expanded Cheat Menu.]],
})
