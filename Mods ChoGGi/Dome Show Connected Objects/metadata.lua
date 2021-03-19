return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 3,
		}),
	},
	"title", "Dome Show Connected Objects",
	"id", "ChoGGi_ShowDomeConnectedObjects",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,
	"image", "Preview.png",
	"steam_id", "2038895989",
	"pops_any_uuid", "42e8c2ef-c183-4488-bce1-0b8b0223c7ba",
	"author", "ChoGGi",
	"lua_revision", 1001551,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagBuildings", true,
	"description", [[Wondering why you can't remove a dome? This mod will show any objects that will block you from doing so.

Mod Options:
Enable Mod: If you want to disable the mod without the mod manager.
Move Invalid Position: Move any objects at an invalid position to the dome when you press the toggle connected objs button (default disabled).
Clean Up Invalid: Remove any invalid objects stuck in the dome when you press the toggle connected objs button (default disabled).

If you see a white line going off to nothing, it's an invalid object (probably).
]],
})
