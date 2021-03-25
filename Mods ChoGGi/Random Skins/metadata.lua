return PlaceObj("ModDef", {
	"title", "Random Skins",
	"id", "ChoGGi_RandomSkins",
	"lua_revision", 1001569,
	"steam_id", "0", -- should hopefully give an error if I forget and post it to steam
	"pops_any_uuid", "7a7c8ea3-1607-4bf1-85cc-e37c91800cf6",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"image", "Preview.png",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
--~ 	"has_options", true,
	"TagBuildings", true,
	"TagCosmetics", true,
	"description", [[Picks a random skin for newly built buildings (after construction phase).

https://steamcommunity.com/sharedfiles/filedetails/?id=1532783670 isn't available on paradox platform, so I made a new mod.]],
})
