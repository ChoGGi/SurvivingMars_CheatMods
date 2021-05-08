return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 9,
		}),
	},
	"title", "Show Resource Overview",
	"version", 4,
	"version_major", 0,
	"version_minor", 4,

	"image", "Preview.png",
	"id", "ChoGGi_ShowResourceOverview",
	"steam_id", "1524654007",
	"pops_any_uuid", "100abb6d-36f4-4e1c-9600-882a52b95c55",
	"author", "ChoGGi",
	"lua_revision", 1001514, -- Tito
	"code", {
		"Code/Script.lua",
	},
	"description", [[This was hidden in Sagan update.
This re-adds the button and has it show up after selection (like it was pre-Sagan).

They didn't actually remove it, just hid the button and changed the function that shows it after you select something.

If you toggle the build menu it'll hide the overview.
You can use the hud button to toggle it, which also stops it from showing up on object select.


Known Issues:
HUD button: For new games it'll be last, for loaded games it'll be in the correct position.

Discussion: https://steamcommunity.com/app/464920/discussions/0/1733214357976953662/]],
})
