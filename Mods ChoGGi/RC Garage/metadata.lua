return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 8,
		}),
	},
	"title", "RC Garage",
	"version", 9,
	"version_major", 0,
	"version_minor", 9,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_RCGarage",
	"steam_id", "1557866331",
	"pops_any_uuid", "fd81692a-a91f-4f22-94f9-ad24a9442e01",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
		"Code/Rovers.lua",
	},
	"description", [[Massive underground connected parking garage for idle rovers, so you don't need to go looking for them.
The more stored the more electricity it uses (0.5 per), and you can't remove any rovers if the main garage isn't working.

The first placed garage is the main one that uses power the rest will draw from it.
There's a button added to the other garages if you want to switch the main.
Each garage is another 1 electricity use.

Comes with built-in rover wash.

Known Issues:
The build menu doesn't show that it uses electricity.

Requested by Valkyrie115.]],
})
