return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 8,
		}),
	},
	"title", "RC Remote",
	"id", "ChoGGi_RCRemote",
	"steam_id", "1667310894",
	"pops_desktop_uuid", "3ccc0532-9857-4515-9c50-6610d323129d",
	"lua_revision", 1007000, -- Picard
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"description", [[
It's an RC Remote or an RC RC. Use WASD to move.
Press E to jump forward. It ignores pathing, so you can use it to get up/down hillsides.
Press Q to fire a missile at the mouse cursor object (useful for removing rocks).
Press Shift to toggle high speed.
All the keys are re-bindable in the game controls.

Known Issues:
I override keyboard controls to use WASD, To get back control select something else (rocks will work).

Requested by stats9.
]],
})
