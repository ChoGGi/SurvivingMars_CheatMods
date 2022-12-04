return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 7,
		}),
	},
	"title", "Passenger Rocket Tweaks",
	"id", "ChoGGi_PassengerRocketTweaks",
	"steam_id", "1641796120",
	"pops_any_uuid", "e27f8c05-6999-4737-8615-5c9820b083ff",
	"lua_revision", 1007000, -- Picard
	"version", 17,
	"version_major", 1,
	"version_minor", 7,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[
Adds an "Are you sure?" question box to the back button to stop you from losing your applicant list (just the button, pressing ESC still works as usual).
Shows age of colonist in popup info.

Mod Options:
Hide Background: Shows a black background so you can see the text easier.
More Spec Info: Add a specialisation count section to the passenger rocket screen (selected applicants / specialists needed by workplaces / specialists already in colony).
Position Pass List: Enable changing position of passenger list.
PosX/PosY: Margins to use for list.
]],
})
