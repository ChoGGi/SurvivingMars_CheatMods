return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Add 5 Times The Resource To Deposits",
	"version_major", 0,
	"version_minor", 5,
	"saved", 1549713600,
	"id", "ChoGGi_Add5TimesTheResourceToDeposits",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua"
	},
	"image","Preview.png",
	"steam_id", "1427609324",
	"lua_revision", LuaRevision or 244124,
	"description", [[Adds a button to water/metal/concrete deposits to multiple the amount of all deposits of the same resource by 5.

Requested by Peacemaker.]],
})