return PlaceObj("ModDef", {
	"title", "Disable Maintenance When Off",
	"id", "ChoGGi_DisableMaintenanceWhenOff",
	"steam_id", "1823134252",
	"pops_any_uuid", "79d0b3b2-e9b4-44df-bd13-31ee7a9d6d0d",
	"lua_revision", 1001569,
	"version", 6,
	"version_major", 0,
	"version_minor", 6,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"TagBuildings", true,
	"description", [[Turn off buildings to stop maintenance buildup.

Mod option to quarter the points build up when turned off (instead of completely stopping it).


Known Issues:
If you leave buildings off for a long time, they'll automagically get stuck in a needs maintenance bugged state.
SkiRich fixed that with this mod: [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2433157820]Fix Forever Maintenance[/url]

]],
})
