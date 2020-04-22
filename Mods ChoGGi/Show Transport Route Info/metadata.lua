return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 8,
			"version_minor", 1,
		}),
	},
	"title", "Show Transport Route Info",
	"version", 5,
	"version_major", 0,
	"version_minor", 5,

	"image", "Preview.png",
	"id", "ChoGGi_ShowTransportRouteInfo",
	"steam_id", "1628726303",
	"pops_any_uuid", "d25a14ac-acf8-4132-bda6-ac116688b011",
	"author", "ChoGGi",
	"lua_revision", 249143,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagInterface", true,
	"description", [[Shows a line connecting the transport route when you select a transporter (also shows res type).
Mod options to show text, icon, or both.

Requested by VladamirBegemot.]],
})
