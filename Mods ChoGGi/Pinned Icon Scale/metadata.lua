return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 6,
		}),
	},
	"title", "Pinned Icon Scale",
	"id", "ChoGGi_PinnedIconScale",
	"steam_id", "2653690138",
	"pops_any_uuid", "1123bd0b-e4aa-462c-af83-be5d18ee2bef",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[
If you have the UI Scale set high, but want smaller pinned icons (or just smaller).
See mod options to set amount.


Requested by TrickyNick77.
]],
})
