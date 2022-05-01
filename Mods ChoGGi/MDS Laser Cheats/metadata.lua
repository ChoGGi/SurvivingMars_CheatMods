return PlaceObj("ModDef", {
	"title", "MDS Laser Cheats",
	"id", "ChoGGi_MDSLaserCheats",
	"steam_id", "2428918892",
	"pops_any_uuid", "69f8402d-8226-4928-828d-b564c5942673",
	"lua_revision", 1007000, -- Picard
	"version", 2,
	"version_major", 0,
	"version_minor", 2,
	"image", "Preview.jpg",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"has_options", true,
	"TagGameplay", true,
	"description", [[Pew pew pew!


Mod Options:
Hit Chance: The chance to hit a meteor.
Fire Rate: Cooldown between shots in seconds.
Protect Range: If meteors would fall within dist range it can be destroyed by the laser (in hexes).
Shoot Range: Range at which meteors can be destroyed. Should be greater than the protection range (in hexes).
Rotate Speed: Platform's rotation speed to target meteor in Deg/Sec.
Beam Time: For how long laser beam is visible (in ms).


If you want super pew pew; then make fire rate 0, and rotate speed max.
Requested by Kommi.]],
})
