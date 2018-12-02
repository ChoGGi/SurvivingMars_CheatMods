return PlaceObj("ModDef", {
	"title", "Minimap v0.2",
	"version", 2,
	"saved", 1543665600,
	"image", "Preview.png",
	"id", "ChoGGi_Minimap",
	"steam_id", "1571476937",
	"author", "ChoGGi",
	"lua_revision", LuaRevision,
	"code", {
		"Code/Minimap.lua",
		"Code/Script.lua",
		"Code/ModConfig.lua",
	},
	"description", [[It's an image of the map you can click on to move the camera around (useful for setting transport routes).
This is an image, so click target isn't perfect.

For those of us using ultrawide the image doesn't work that well, 16:9 is best.
There's a ModConfig option to use my topography images instead:
https://steamcommunity.com/sharedfiles/filedetails/?id=1571465108

If the camera view gets messed up then zoom in and out a couple times to fix it.]],
})
