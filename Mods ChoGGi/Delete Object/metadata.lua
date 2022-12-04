return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 7,
		}),
	},
	"title", "Delete Object",
	"id", "ChoGGi_DeleteObject",
	"steam_id", "2743285577",
	"pops_any_uuid", "881d7130-03b4-46c5-97e6-6ce07d2bfcb3",
	"lua_revision", 1007000, -- Picard
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
Adds a button to forcefully delete the selected object.
Mod option to turn off the button.


[b]Deleting Domes[/b]: You must remove objects in it and connected to it. Use this mod to see them:
https://steamcommunity.com/workshop/filedetails/?id=2038895989


Relatively requested by Ericus1
]],
})
