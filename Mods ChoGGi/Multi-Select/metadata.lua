return PlaceObj("ModDef", {
	"title", "Multi-Select v0.2",
--~ 	"title", "Multi-Select v0.1",
	"version", 2,
	"saved", 1552478400,
	"image", "Preview.png",
	"id", "ChoGGi_MultiSelect",
	"steam_id", "1673928672",
	"pops_desktop_uuid", "d9ea47ff-e175-416f-bcf0-fa8ce3ac4cc0",
	"author", "ChoGGi",
	"lua_revision", LuaRevision or 243725,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Press Shift-Left mouse and drag to create a radius and select all units within that radius (drones/rovers).
Double Shift-Click a unit to select all units of the same class in the last used radius.
Shift-Click a unit to add/remove that unit from the selection.

Works with most actions, anything that opens up a menu to pick from a list will not work.]],
})
