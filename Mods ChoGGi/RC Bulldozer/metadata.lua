return PlaceObj("ModDef", {
  "title", "RC Bulldozer v0.4",
  "version", 4,
  "saved", 1540036800,
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

Options to change the radius, show a circle where it flattens, and change the ground texture (or turn it off).
The buildable area won't be updated till you turn off Dozer Toggle (expensive function call).


Known issues:
The sides of ground on tall hills don't look that good, you can use my Terraformer mod to smooth them.]],
})
