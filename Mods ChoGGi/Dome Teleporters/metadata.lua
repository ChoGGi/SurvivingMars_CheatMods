return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Dome Teleporters",
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"saved", 1555156800,
	"image", "Preview.png",
	"id", "ChoGGi_DomeTeleporters",
	"steam_id", "1572847416",
	"pops_any_uuid", "9d8cb03c-6e7b-440e-b8d5-9542d12fd003",
	"author", "ChoGGi",
	"lua_revision", 244275,
	"code", {
		"Code/Script.lua",
		"Code/TeleporterConstruction.lua",
		"Code/TeleporterLines.lua",
	},
	"has_options", true,
	"description", [[In-dome teleporters that act like passages (also shows connected lines when you select one).
This will allow you to have pure resident domes that connect to the work/leisure domes.
You can set shifts that colonists are allowed to use the teleporter.
Treat these like regular passages, as they share some of the same limitations.

Length defaults to tunnel length, use Mod Config Reborn to change.

Known Issues:
If you turn it off, then the colonists will group up in front of it (I figured that was better then them quitting and so on).
Suicidal colonists: Pathing wise it's best to only use teleporters with domes close by each other, or with some inaccessible land in the way, else they'll sometimes just go for The Long Walk.
This is a bug with base game, if you build domes in a half-circular pattern then colonists from the two ends will try walking outside and die.

Mods:
Colonists Use Shuttles For Work:
https://steamcommunity.com/sharedfiles/filedetails/?id=1669365353
True Dome Network:
https://mods.paradoxplaza.com/mods/630/Any



Requested by... Probably a bunch of people, inspired by veryinky though.
]],
})
