return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 0,
		}),
	},
	"title", "Dome Show Connected Objects",
	"id", "ChoGGi_ShowDomeConnectedObjects",
	"pops_any_uuid", "42e8c2ef-c183-4488-bce1-0b8b0223c7ba",
	"steam_id", "2038895989",
	"lua_revision", 1007000, -- Picard
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"description", [[
Wondering why you can't remove a dome? This mod will show any objects that will block you from doing so.

Mod Options:
[b]Enable Mod[/b]: Disable mod without having to see missing mod msg.
[b]Move Invalid Position[/b]: Move any objects at an invalid position to the dome when you press the toggle connected objs button (default disabled).
[b]Clean Up Invalid Objects[/b]: Remove any invalid objects stuck in the dome when you press the toggle connected objs button (default disabled).

If you see a white line going off to nothing, it's an invalid object.
]],
})
