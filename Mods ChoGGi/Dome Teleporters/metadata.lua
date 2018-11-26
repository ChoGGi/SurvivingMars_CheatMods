return PlaceObj("ModDef", {
	"title", "Dome Teleporters v0.4",
	"version", 4,
	"saved", 1543233600,
	"image", "Preview.png",
	"id", "ChoGGi_DomeTeleporters",
	"steam_id", "1572847416",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/ModConfig.lua",
		"Code/Script.lua",
		"Code/TeleporterConstruction.lua",
		"Code/TeleporterLines.lua",
	},
	"description", [[In-dome teleporters that act like passages (shows connected lines when you select one).
This will allow you to have pure resident domes that connect to the work/leisure domes.
You can set shifts that colonists are allowed to use the teleporter.

Length defaults to tunnel length, use ModConfig to change.

Known Issues:
If you turn it off, then the colonists will group up in front of it (I figured that was better then them quitting and so on).


Requested by... Probably a bunch of people, inspired by veryinky though.
]],
})
