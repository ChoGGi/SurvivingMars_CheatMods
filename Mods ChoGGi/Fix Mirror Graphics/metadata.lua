return PlaceObj("ModDef", {
	"title", "Fix Mirror Graphics",
	"id", "ChoGGi_FixMirrorGraphics",
	"steam_id", "2549884520",
--~ 	"pops_any_uuid", "bc22317d-d723-4a4c-9814-919eefe38f02",
	"pops_any_uuid", "dd12bda4-8092-44c9-8f25-b17a34e4ec6e",
	"lua_revision", 1001514, -- Tito
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagOther", true,
	"description", [[
Not so much a fix as changing textures to other ones that don't show the ugly mirrored textures.
Terraforming will still look ugly, but at least there's no mirror holes in the ground.
If you use my Show All Textures mod; you can see a list of textures to use. Suggestions are welcome if you think something would look better.

By default this mod only changes dumping sites, see mod options to enable other textures you need changed.


Known Issues:
There is a mod option to disable the mod, but once textures are remapped it's part of the save so no backsies.
You'll probably have to stick with these textures till you start a new game, or disable this mod and rebuild anything changed (as terraforming changes stuff it should go back to proper textures if disabled).
]],
})
