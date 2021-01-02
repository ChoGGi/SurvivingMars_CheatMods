return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 9,
		}),
	},
	"title", "Construction Show Dome Passage Line",
	"version", 13,
	"version_major", 1,
	"version_minor", 3,
	"id", "ChoGGi_ConstructionShowDomePassageLine",
	"author", "ChoGGi",
	"image", "Preview.png",
	"steam_id", "1428027914",
	"pops_any_uuid", "64d161e9-828a-41c9-bdfc-61b9790405e8",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Shows lines between domes when they're close enough for passages to connect.

I use straight lines, instead of the angled passages, so it isn't perfect.
There is a chance that you'll be able to connect a dome that's another 1-5 hexes further away (dependant on the angle).
The mod checks for Construction Extend Length and Longer Passages Tech mods and uses the extended length.
This doesn't take into account entrances, corners, or buildings.


Mod Options:
Show during construction: Disable it.
Adjust Line Length: I use a safe distance, you can increase it if you want (under 5 and corners may trip you up).


Known Issues:
Pause the game while placing if you have a lot of domes to speed it up.
]],
})
