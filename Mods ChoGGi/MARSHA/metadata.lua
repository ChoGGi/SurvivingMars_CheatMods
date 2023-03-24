return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 8,
		}),
	},
	"title", "MARSHA",
	"id", "ChoGGi_OutsideResidence",
	"pops_any_uuid", "8f3295f3-b7bb-4a5c-a81e-1876271c28d1",
	"steam_id", "1775121099",
	"lua_revision", 1007000, -- Picard
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"TagBuildings", true,
	"description", [[
Stores some colonists outside.
The building feeds off the nearest dome and has low comfort (2.5), but it only needs concrete for maintenance.
30 Concrete, 5 Polymers to build. Entity may look different depending on what DLC you have.

@Xboxers Until the Paradox fixes it; I can't change the titles of mods... [url=https://mods.paradoxplaza.com/mods/955/Any]MARSHA[/url]


Requested by Destrada.
]],
})
