return PlaceObj("ModDef", {
	"title", "Disable Pause",
	"version", 1,
	"version_major", 0,
	"version_minor", 2,
	"id", "ChoGGi_DisablePause",
	"image", "Preview.png",
	"steam_id", "1579991229",
--~ 	"pops_any_uuid", "860f6a4a-cfc6-4b9a-bc65-55d704da1171", (stuck on desktop)
	"pops_desktop_uuid", "2dcb61f7-1c9e-4932-b19a-50301f32b81e",
	"author", "ChoGGi",
	"lua_revision", 1007000, -- Picard
	"code", {
		"Code/Script.lua",
	},
	"description", [[
Space sets speed to normal, and the pause button is hidden.


Requested by Charlie Pryor.
]],
})
