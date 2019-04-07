return PlaceObj("ModDef", {
	"title", "Fix: Grid Not Working v0.1",
	"version", 1,
	"saved", 1538481600,
	"image", "Preview.png",
	"id", "ChoGGi_FixGridNotWorking",
	"steam_id", "1528605256",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 243725,
	"code", {
		"Code/Script.lua",
	},
	"description", [[When you load a save this will go through the grids and check for objects that shouldn't be in there.

If your batteries haven't been charging since the Sagan update this will fix it.

You can remove afterwards.]],
})
