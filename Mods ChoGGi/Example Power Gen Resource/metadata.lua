return PlaceObj("ModDef", {
	"title", "Example Power Gen Resource",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,

	"image", "Preview.png",
	"id", "ChoGGi_ExamplePowerGenResource",
--~ 	"steam_id", "000000000",
--~ CopyToClipboard([[	"pops_any_uuid", "]] .. GetUUID() .. [[",]])
	"author", "ChoGGi",
	"lua_revision", 1001514,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Uses WasteRock to generate power.]],
})
