return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Change Rocket Position v0.1",
	"version", 1,
	"saved", 1554724800,
	"image", "Preview.png",
	"id", "ChoGGi_ChangeRocketPosition",
	"steam_id", "1707472695",
	"pops_desktop_uuid", "c2854565-a76e-473a-8464-47349176169f",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 243725,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Adds a button to rockets that lets you re-position the rocket.
Costs 10 fuel per re-position.]],
})
