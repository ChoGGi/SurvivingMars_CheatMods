return PlaceObj("ModDef", {
	"title", "Fix: Drones Carry Amount v0.8",
	"version", 8,
	"saved", 1539950400,
	"image", "Preview.png",
	"tags", "Building",
	"id", "ChoGGi_DronesCarryAmountFix",
	"steam_id", "1411107961",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"lua_revision", LuaRevision,
	"description", [[Drones normally only pick up resources from buildings when the amount stored is equal or greater to their carry amount (ex: if there's 1 res cube and you have the 2x carry upgrade they'll wait for another res cube before they touch it).

This mod forces them to pick up whenever there's at least 1 res cube.

This mod is useless unless you have a mod/cheat that increases how much they can carry.


Part of Expanded Cheat Menu.]],
})
