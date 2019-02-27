return PlaceObj("ModDef", {
	"title", "Dome Teleporters v0.5",
	"version", 5,
	"saved", 1543233600,
	"image", "Preview.png",
	"id", "ChoGGi_DomeTeleporters",
	"steam_id", "1572847416",
	"pops_any_uuid", "9d8cb03c-6e7b-440e-b8d5-9542d12fd003",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/ModConfig.lua",
		"Code/Script.lua",
		"Code/TeleporterConstruction.lua",
		"Code/TeleporterLines.lua",
	},
	"description", [[In-dome teleporters that act like passages (also shows connected lines when you select one).
This will allow you to have pure resident domes that connect to the work/leisure domes.
You can set shifts that colonists are allowed to use the teleporter.
Treat these like regular passages, as they share some of the same limitations.

Length defaults to tunnel length, use Mod Config Reborn to change.

Known Issues:
If you turn it off, then the colonists will group up in front of it (I figured that was better then them quitting and so on).
Suicidal colonists: Pathing wise it's best to only use teleporters with domes close by each other, or with some inaccessible land in the way, else they'll sometimes just go for The Long Walk.
This is a bug with base game, if you build domes in a half-circular pattern then colonists from the two ends will try walking outside and die.



Requested by... Probably a bunch of people, inspired by veryinky though.
]],
})
