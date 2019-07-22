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
I haven't figured out the grid connection funcs to be able to use the dome edges.
Check the selection panel after placing one, if it says Connected to building then it'll work.
See the screenshots above to know which hexes work.


Known Issues:
I was more concerned with removing limitations than setting new ones, so you can build them in stupid places.]],
})
