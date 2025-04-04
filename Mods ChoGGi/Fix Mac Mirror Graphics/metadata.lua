return PlaceObj("ModDef", {
	"title", "Fix Mac Mirror Graphics",
	"id", "ChoGGi_FixMirrorGraphics",
	"steam_id", "2549884520",
	"pops_any_uuid", "dd12bda4-8092-44c9-8f25-b17a34e4ec6e",
	"lua_revision", 1007000, -- Picard
	"version", 10,
	"version_major", 1,
	"version_minor", 0,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
Not so much a fix as changing textures to other ones that don't show the ugly mirrored textures. Terraforming will be more red instead of green ground, but at least there's no mirror ground.


By default this mod only changes dumping sites/outside grass, see mod options to enable other textures you need changed.


Known Issues:
There is a mod option to disable the mod, but once textures are remapped it's part of the save so no backsies.
You'll probably have to stick with these textures till you start a new game, or disable this mod and rebuild anything changed (as terraforming changes stuff it should go back to proper textures if disabled).

Keywords: Intel Iris Xe, mac, OSX, macOS, m1, m2, m3, textures
]],
})
