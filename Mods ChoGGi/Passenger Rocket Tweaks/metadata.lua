return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 6,
			"version_minor", 4,
		}),
	},
--~ 	"title", "Passenger Rocket Tweaks v0.2",
	"title", "Passenger Rocket Tweaks",
	"version", 5,
	"version_major", 0,
	"version_minor", 5,
	"saved", 1558094400,
	"image", "Preview.png",
	"id", "ChoGGi_PassengerRocketTweaks",
	"steam_id", "1641796120",
	"pops_any_uuid", "e27f8c05-6999-4737-8615-5c9820b083ff",
	"author", "ChoGGi",
	"lua_revision", 244677,
	"code", {
		"Code/Script.lua",
	},
	"description", [[Various tweaks to the passenger list screen.

Adds an "Are you sure?" question box to the back button to stop you from losing your applicant list (just the button, pressing ESC still works as usual).
Optional:
Add a specialisation count section to the passenger rocket screen (selected applicants / specialists needed by workplaces / specialists already in colony).
Position passenger list using x/y coords.

Mod Options:
More Spec Info: Show more specialist info.
Position Pass List: Enable changing position of passenger list.
PosX/PosY: Margins to use for list.
]],
	"has_options", true,
})
