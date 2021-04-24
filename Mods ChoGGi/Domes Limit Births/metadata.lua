return PlaceObj("ModDef", {
	"title", "Domes Limit Births",
	"version", 3,
	"version_major", 0,
	"version_minor", 3,
	"image", "Preview.png",
	"id", "ChoGGi_DomesLimitBirths",
	"steam_id", "1736467180",
	"pops_any_uuid", "cef541f6-a547-4bcf-a6ed-e4aa521bb937",
	"author", "ChoGGi",
	"lua_revision", 1001514, -- Tito
	"code", {
		"Code/Script.lua",
	},
	"description", [[Adds a slider to domes to limit amount of children born in each dome.
The slider will stop babies from being born in that dome (nothing else).
This is a slightly random birth limiter, once they're allowed it'll spawn however many are in the queue.
If you want something more exact, see my Nursery: Limit Birthing To Spots mod.

It defaults to 0 (vanilla functionality), raise it to set a limit.
Click the title to toggle between changing the value for that dome or all domes.

The value is per-dome unless you change it for all domes.


Requested by BrowncoatTrekky.]],
})
