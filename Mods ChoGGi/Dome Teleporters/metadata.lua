return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 3,
		}),
	},
	"title", "Dome Teleporters",
	"id", "ChoGGi_DomeTeleporters",
	"steam_id", "2785527541",
	"pops_any_uuid", "115ac1c8-5e7d-4204-b7b0-4a7fd0baec0f",
	"lua_revision", 1007000, -- Picard
	"version", 17,
	"version_major", 1,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Possible game crashing issue.
I did some work on it, but I can't make it crash...




In-dome teleporters that act like passages (also shows connected lines when you select one).
This will allow you to have pure resident domes that connect to the work/leisure domes.
You can set shifts that colonists are allowed to use the teleporter.
Treat these like regular passages, as they share some of the same limitations.

Length defaults to tunnel length, use Mod Options to change.

Known Issues:
If you turn it off, then the colonists will group up in front of it (I figured that was better then them quitting and so on).
Suicidal colonists: Pathing wise it's best to only use teleporters with domes close by each other, or with some inaccessible land in the way, else they'll sometimes just go for The Long Walk.
This is a bug with base game, if you build domes in a half-circular pattern then colonists from the two ends will try walking outside and die.
Use this to fix it: [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1811507300]Fix Colonist Long Walks[/url]



True Dome Network:
https://mods.paradoxplaza.com/mods/630/Any



Requested by... Probably a bunch of people, inspired by veryinky though.
]],
})
