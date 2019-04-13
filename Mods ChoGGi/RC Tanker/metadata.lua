return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library v6.4",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
	"title", "RC Tanker v0.2",
	"version_major", 0,
	"version_minor", 2,
	"saved", 1550750400,
	"image", "Preview.png",
	"id", "ChoGGi_RCTanker",
	"steam_id", "1653353483",
	"pops_any_uuid", "aaa0130c-0757-4938-8b57-0d5cded4e892",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 243725,
	"code", {
		"Code/Script.lua",
		"Code/ModConfig.lua",
	},
	"description", [[Allows you to drain an oxygen or water tank, and fill another tank.
Adds two buttons to the selection panel: One to switch between draining and filling, and one to switch the resource type.

By default it can hold an unlimited amount, includes a Mod Config Reborn setting to limit it to X units (if you feel it's too cheap).

Depending on DLC installed RC and tank will use different models.]],
})
