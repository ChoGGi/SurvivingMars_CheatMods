return PlaceObj("ModDef", {
--~ 	"title", "Save Rocket Cargo",
	"title", "Save Rocket Cargo v0.1",
	"version", 1,
	"saved", 1552478400,
	"image", "Preview.png",
	"id", "ChoGGi_SaveRocketCargo",
	"steam_id", "1681523723",
	"pops_any_uuid", "983cde10-49f0-4aab-b882-9061ca99b0ee",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Stops rocket cargo from being removed when you leave the rocket screen.

Closing the rocket dialog is when the cargo is saved, so switching from the pod cargo to the elevator will not save the pod cargo.
The cargo will remain saved till you quit or load a different game.

Requested by... A bunch of people, but the last was Sigmatics.]],
})
