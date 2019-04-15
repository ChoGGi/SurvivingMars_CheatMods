return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Random Object Colour",
	"version_major", 0,
	"version_minor", 2,
	"saved", 1539950400,
	"image", "Preview.png",
	"id", "ChoGGi_RandomBuildingColour",
	"steam_id", "1535187230",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Changes the colours of objects to random colours when placed.

If someone wants the colours reset, let me know and I'll add something to Expanded Cheat Menu or this (whatever is easier).

Requested by McKaby]],
})
