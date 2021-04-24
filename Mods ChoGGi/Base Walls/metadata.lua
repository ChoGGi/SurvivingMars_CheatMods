return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 7,
		}),
	},
	"title", "Base Walls",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,

	"image", "Preview.png",
	"id", "ChoGGi_BaseWalls",
	"steam_id", "1762913666",
	"pops_any_uuid", "74e00a2d-11ef-43a7-9443-cdfe7513e787",
	"author", "ChoGGi",
	"lua_revision", 1001514, -- Tito
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagBuildings", true,
	"TagOther", true,
	"description", [[Same basic idea as ErrantSword's mod, with a few changes:
There's no electrical grid added to them.
I used mini dome passages (sorry no fancypants dragging), and some other entities (for "corner" hubs).
They will block drones from pathing through them.
They're also free/instant build, 'cause why not?
The change skin will switch between the passage skins.
Use Shift-E/Shift-Q while building to adjust the length (change in Options>Bindings).
I tried adding gamepad bindings, but it seems to eat them (no error msgs).

There are buttons you can use to rotate/adjust length once placed (gamepads do work with them).

You may need to use [url=https://steamcommunity.com/sharedfiles/filedetails/1763802580]Remove Building Limits[/url] when adding more than one to a single hex area.


Known Issues:
Holding shift to place multiples doesn't work yet.
]],
})
