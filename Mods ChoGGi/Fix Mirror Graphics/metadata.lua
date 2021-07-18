return PlaceObj("ModDef", {
	"title", "Fix Mirror Graphics",
	"id", "ChoGGi_FixMirrorGraphics",
	"steam_id", "2549884520",
	"pops_any_uuid", "bc22317d-d723-4a4c-9814-919eefe38f02",
	"lua_revision", 1001514, -- Tito
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
By default this mod only changes dumping sites and dome grass, see mod options to enable other textures you need changed.

Not so much a fix as changing textures to something that doesn't show the ugly mirrored textures.
If you want to see soil quality; you'll need to use a forestation plant to toggle the soil view.


Known Issues:
You'll probably have to stick with these textures till you start a new game, or disable this mod and rebuild anything changed.
There is a mod option to disable the mod, but once textures are remapped it's part of the save so no backsies.
]],
})
