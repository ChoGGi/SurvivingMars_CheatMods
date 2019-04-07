return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Auto Empty Waste Storage v0.4",
	"version", 4,
	"saved", 1539950400,
	"id", "ChoGGi_AutoEmptyWasteStorage",
	"author", "ChoGGi",
	"image","Preview.png",
	"code", {
		"Code/Script.lua"
	},
	"lua_revision", LuaRevision or 243725,
	"steam_id", "1485526508",
	"description", [[Automatically empties waste storage sites.

Use Mod Config to toggle enabled, and hourly/daily empty.]],
})
