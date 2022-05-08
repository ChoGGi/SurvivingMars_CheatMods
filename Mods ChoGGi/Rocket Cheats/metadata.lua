return PlaceObj("ModDef", {
	"dependencies", {
		PlaceObj("ModDependency", {
			"id", "ChoGGi_Library",
			"title", "ChoGGi's Library",
			"version_major", 11,
			"version_minor", 4,
		}),
	},
	"title", "Rocket Cheats",
	"id", "ChoGGi_RocketCheats",
	"steam_id", "2429782883",
	"pops_any_uuid", "1e254009-499e-4e01-a948-81e98fc661e3",
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
	"TagGameplay", true,
	"description", [[Fiddle with rockets

Mod Options:
Launch Fuel: The amount of fuel it takes to launch the rocket.
Max Export Storage: How many rares on one rocket.
Passenger Orbit Lifetime: Passengers on board will die if the rocket doesn't land this many hours after arriving in orbit.
Payload Capacity: Maximum payload (in kg) of a resupply Rocket
Food per Rocket Passenger: The amount of Food (unscaled) supplied with each Colonist arrival
Colonists per Rocket: Maximum number of Colonists that can arrive on Mars in a single Rocket
Rocket Travel Time (Earth to Mars): Time it takes for a Rocket to travel from Earth to Mars
Rocket Travel Time (Mars to Earth): Time it takes for a Rocket to travel from Mars to Earth
Rocket Price: In Millions.


Known Issues:
It doesn't affect first rocket launch.
When you research cargo extension tech changes are reset (apply options again or reload save).
]],
})
