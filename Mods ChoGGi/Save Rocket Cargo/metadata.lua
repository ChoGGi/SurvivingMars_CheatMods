return PlaceObj("ModDef", {
	"title", "Save Rocket Cargo",
	"id", "ChoGGi_SaveRocketCargo",
	"steam_id", "1681523723",
	"pops_any_uuid", "983cde10-49f0-4aab-b882-9061ca99b0ee",
	"lua_revision", 1007000, -- Picard
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Stops rocket cargo from being removed when you leave the rocket screen.

Closing the rocket dialog is when the cargo is saved, so switching from the pod cargo to the elevator will not save the pod cargo.
The cargo will remain saved till you quit or load a different game.
There's a Clear button added to the cargo screen for "issues', see tooltip for more info.

Mod Options:
Clear On Launch: Clear cargo for rocket/pod/elevator when launched (not all cargo, just for the same type).

Requested by... A bunch of people, but the last was Sigmatics.
]],
})
