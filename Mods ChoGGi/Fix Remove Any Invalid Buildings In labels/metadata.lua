return PlaceObj("ModDef", {
	"title", "Fix: Remove Invalid Label Buildings v0.1",
	"version_major", 0,
	"version_minor", 1,
	"saved", 000000000,
	"image", "Preview.png",
	"id", "ChoGGi_FixRemoveInvalidLabelBuildings",
	"steam_id", "1575894376",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244124,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Labels are a place where the game stores buildings and whatnot.
I came across a non-modded 700 Sol+ game (thanks marklion29) that had some invalid buildings in the labels.
This won't remove any buildings, just the reference in the label list (invalid meaning it isn't an actual obj, so nothing to remove).

I don't know if this will "help" anything, but it won't hurt...]],
})
