return PlaceObj("ModDef", {
	"title", "Passages Use Empty Hexes",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,
	"saved", 0,
	"image", "Preview.png",
	"id", "ChoGGi_PassagesUseEmptyHexes",
	"steam_id", "1809321641",
	"pops_any_uuid", "2273f89a-7721-4550-b777-024352538af9",
	"author", "ChoGGi",
	"lua_revision", 245618,
	"code", {
		"Code/Script.lua",
	},
	"TagGameplay", true,
	"description", [[Passage restrictions are relaxed.
For now this is ONLY useful for the Medium, Mega, and Geoscape domes.

You can only use certain hexes to connect domes. Look at the screenshots above to see which hexes work.
Check the selection panel after placing a passage site, if it says "Connected to building" then it'll work, if it says "No dome" then remove the site and try again.


Known Issues:
I was more concerned with removing limitations than setting new ones, so you can build them in stupid places (if it doesn't place a complete passage then remove it).]],
})
