return PlaceObj("ModDef", {
	"id", "ChoGGi_ShowResearchProgressonHUD2",
	"title", "Show Research Progress on HUD 2",
	"steam_id", "1757762374",
	"pops_desktop_uuid", "c4500700-e512-451c-8770-decb8e8a148c",
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.png",
	"author", "Waywocket & ChoGGi",
	"lua_revision", 1001514, -- Tito
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagResearch", true,
	"TagInterface", true,
	"description", [[Adds a progress bar to the HUD, showing the progress of the active research.
As Waywocket mentioned he's abandoned this mod, so I figured I'd update it.

Mod Options:
Show Number in Queue: Show a count of the number of technologies currently in the research queue.
Hide When Queue is Empty: When the research queue is empty, hide it entirely.

Differences from original:
Displays whatever is being researched if queue is empty, so no more red bar.
Added list of queued tech to the tooltip.
The progress bar is displayed above the speed buttons (for less extra HUD background padding).
If you want it below the time of day bar then I can add an option.]],
})
