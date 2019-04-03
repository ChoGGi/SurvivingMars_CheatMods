return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
--~ 	"title", "RC Garage v0.3",
	"title", "RC Garage v0.4",
	"version", 4,
	"saved", 1552219200,
	"image", "Preview.png",
	"id", "ChoGGi_RCGarage",
	"steam_id", "1557866331",
	"pops_any_uuid", "fd81692a-a91f-4f22-94f9-ad24a9442e01",
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
