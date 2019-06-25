return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 7,
			"version_minor", 0,
		}),
	},
--~ 	"title", "Construction: Show Dome Passage Line v0.9",
	"title", "Construction Show Dome Passage Line",
	"version", 10,
	"version_major", 1,
	"version_minor", 0,
	"saved", 0,
	"id", "ChoGGi_ConstructionShowDomePassageLine",
	"author", "ChoGGi",
	"image", "Preview.png",
	"steam_id", "1428027914",
	"pops_any_uuid", "33973dda-42d6-49a0-ba55-3ec431602574",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Shows lines between domes when they're close enough for passages to connect.

I use straight lines, instead of the angled passages, so it isn't perfect.
There is a chance that you'll be able to connect a dome that's another 1-5 hexes further away (dependant on the angle).

Mod Options:
Show during construction: Disable it.
Adjust Line Length: I use a safe distance, you can increase it if you want (under 5 and corners may trip you up).

This doesn't take into account entrances, corners, or buildings.]],
})
