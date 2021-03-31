return PlaceObj("ModDef", {
	"title", "Fix Colonist Daily Interest Loop",
	"id", "ChoGGi_FixColonistDailyInterestLoop",
	"steam_id", "2441207618",
	"pops_any_uuid", "0f0cca27-231c-4ab1-b5e7-6d698f0dcfa6",
	"lua_revision", 1001569,
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[
A colonist will repeatedly use a daily interest building to satisfy a daily interest already satisfied.
Repeating a daily interest will gain a comfort boost "if" colonist comfort is below the service comfort threshold, but a resource will always be consumed each visit.

An unemployed scientist will wander around outside till the Sol is over instead of chewing up 0.6 electronics.


Mod option to disable.

https://forum.paradoxplaza.com/forum/threads/surviving-mars-colonists-repeatedly-satisfy-daily-interests.1464969/
Requested by ThereWillBeBugsToOvercome.
]],
})
