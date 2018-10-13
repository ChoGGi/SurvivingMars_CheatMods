return PlaceObj("ModDef", {
  "title", "RC Bulldozer v0.1",
  "version", 1,
  "saved", 1539432000,
	"image", "Preview.png",
  "tags", "Buildings",
  "id", "ChoGGi_RCBulldozer",
  "author", "ChoGGi",
  "steam_id", "1538213471",
  "code", {
		"Code/Script.lua",
	},
	"lua_revision", LuaRevision,
  "description", [[Flattens the ground in front of it.
This bulldozer is very shy when it comes to bumpy ground...

Options to change the radius, show a circle where it flattens, and change the ground texture.

Known issues:
The sides of ground don't look that good, you can use Terraformer to smooth them.
It has to re-build the buildable terrain grid whenever it stops, so slight lag spike.
You have to fiddle with getting it to drive in the right spot (like I said shy), drop/remove a construction site to update driveable.]],
})
