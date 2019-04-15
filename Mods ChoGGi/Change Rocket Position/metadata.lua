return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "Change Rocket Position",
	"version_major", 0,
	"version_minor", 1,
	"saved", 1554724800,
	"image", "Preview.png",
	"id", "ChoGGi_ChangeRocketPosition",
	"steam_id", "1707472695",
	"pops_desktop_uuid", "c2854565-a76e-473a-8464-47349176169f",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244124,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Adds a button to rockets that lets you re-position the rocket.
Costs 10 fuel per re-position.


Known Issues:
Any stored rare metals will get "delivered" to Earth.]],
})
