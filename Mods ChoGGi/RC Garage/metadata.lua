return PlaceObj("ModDef", {
	"title", "RC Garage v0.3",
	"version", 3,
	"saved", 1544356800,
	"image", "Preview.png",
	"id", "ChoGGi_RCGarage",
	"steam_id", "1557866331",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Script.lua",
		"Code/Rovers.lua",
	},
	"description", [[Massive underground connected parking garage for idle rovers, so you don't need to go looking for them.
The more stored the more electricity it uses (0.5 per), and you can't remove any rovers if the main garage isn't working.

The first placed garage is the main one that uses power the rest will draw it from (unless you remove it then it's a randomly different one).
Each added garage is another 1 electricity use.

Comes with built-in rover wash.

Known Issues:
The build menu doesn't show that it uses electricity.

Requested by Valkyrie115.]],
})
