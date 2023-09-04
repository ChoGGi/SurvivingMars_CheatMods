return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 12,
			"version_minor", 1,
		}),
	},
	"title", "RC Bulldozer",
	"id", "ChoGGi_RCBulldozer",
	"steam_id", "1538213471",
	"pops_any_uuid", "1fd50db9-6c10-4271-a89b-af02e369d5d8",
	"lua_revision", 1007000, -- Picard
	"version", 11,
	"version_major", 1,
	"version_minor", 1,
	"author", "ChoGGi",
	"image", "Preview.jpg",
	"code", {
		"Code/Script.lua",
	},
	"description", [[
Obsolete: Use landscaping tools (still being updated for bugs).



Flattens the ground in front of it.

Options to change the radius, show a circle where it flattens, and change the ground texture (or turn it off).
The buildable area won't be updated till you turn off Dozer Toggle (expensive function call).


Known issues:
You can't place objects nearby the dozer when Dozer Toggle is enabled.
The sides of ground on tall hills don't look that good, you can use my Terraformer mod to smooth them.
Don't use near Philosopher's stones (the green stones).
]],
})
