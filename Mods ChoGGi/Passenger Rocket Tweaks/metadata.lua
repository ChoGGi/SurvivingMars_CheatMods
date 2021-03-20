return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 9,
			"version_minor", 5,
		}),
	},
	"title", "Passenger Rocket Tweaks",
	"version", 12,
	"version_major", 1,
	"version_minor", 2,
	"image", "Preview.png",
	"id", "ChoGGi_PassengerRocketTweaks",
	"steam_id", "1641796120",
	"pops_any_uuid", "e27f8c05-6999-4737-8615-5c9820b083ff",
	"author", "ChoGGi",
	"lua_revision", 1001551,
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"description", [[Adds an "Are you sure?" question box to the back button to stop you from losing your applicant list (just the button, pressing ESC still works as usual).

Mod Options:
More Spec Info: Add a specialisation count section to the passenger rocket screen (selected applicants / specialists needed by workplaces / specialists already in colony).
Hide Background: Shows a black background so you can see the text easier.
Position Pass List: Enable changing position of passenger list.
PosX/PosY: Margins to use for list.
]],
})
