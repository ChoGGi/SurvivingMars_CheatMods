return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 2,
		}),
	},
	"title", "Add 5 Times The Resource To Deposits",
	"version", 6,
	"version_major", 0,
	"version_minor", 6,

	"id", "ChoGGi_Add5TimesTheResourceToDeposits",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua"
	},
	"image", "Preview.png",
	"steam_id", "1427609324",
	"pops_any_uuid", "6ff9709d-3a3b-48b5-be2f-ce3216aa5699",
	"lua_revision", 1001551,
	"description", [[Adds a button to water/metal/concrete deposits to multiple the amount of all deposits of the same resource by 5.

Requested by Peacemaker.]],
})