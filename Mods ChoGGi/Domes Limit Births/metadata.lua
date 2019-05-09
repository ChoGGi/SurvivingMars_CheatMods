return PlaceObj("ModDef", {
	"title", "Domes: Limit Births",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"saved", 1557316800,
	"image", "Preview.png",
	"id", "ChoGGi_DomesLimitBirths",
	"steam_id", "1736467180",
	"pops_any_uuid", "cef541f6-a547-4bcf-a6ed-e4aa521bb937",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 244275,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Adds a slider to domes to limit amount of children born in each dome.
The slider will stop babies from being born in that dome (nothing else).

It defaults to 0 (vanilla functionality), raise it to set a limit.
Click the title to toggle between changing the value for that dome or all domes.


Requested by BrowncoatTrekky.]],
})
