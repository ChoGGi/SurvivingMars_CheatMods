return PlaceObj("ModDef", {
	"title", "Add Water Each Sol",
	"id", "ChoGGi_AddWaterEachSol",
	"steam_id", "1440164001",
	"pops_any_uuid", "370cf581-9210-435e-8457-1d2685195ce8",
	"lua_revision", 1007000, -- Picard
	"version", 7,
	"version_major", 0,
	"version_minor", 7,
	"author", "ChoGGi",
	"image", "Preview.png",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Add water to any visible surface deposits each new Sol.

This will not increase the capacity, so if the deposit is full that's it.

Mod Options:
Water Per Sol: How much water each deposit receives each Sol.
Follow Water Parameter: Ignore Water Per Sol and add water based on water terraforming parameter.
]],
})
