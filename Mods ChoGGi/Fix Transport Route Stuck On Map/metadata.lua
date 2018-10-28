return PlaceObj("ModDef", {
	"title", "Fix: Transport Route Stuck On Map v0.3",
	"version", 3,
	"saved", 1538395200,
	"image", "Preview.png",
	"id", "ChoGGi_FixTransportRouteStuckOnMap",
	"steam_id", "1526896729",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Script.lua",
	},
	"description", [[While making a transport route with the RC, certain things will pull focus away and leave the grid/blue RC stuck on your map.

This prevents that from happening and when you load a game will look for and remove any left over (from before enabling this mod).



First timers: You need to enable mods with the in-game mod manager at the main menu.]],
})
