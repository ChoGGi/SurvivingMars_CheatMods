return PlaceObj("ModDef", {
	"title", "Fake Personal Information",
	"version", 1,
	"version_major", 0,
	"version_minor", 1,

	"id", "ChoGGi_FakePersonalInformation",
	"author", "ChoGGi",
	"code", {
		"Code/Script.lua",
	},
	"image", "Preview.png",
	"lua_revision", 1001569,
	"description", [[I don't care for a game storing my personal information.
This changes all your stored info to the info for Haemimont Games and/or the CEO (thanks Google).

This changes g_ParadoxHashedUserId... Which might be used for cloud saves (thanks SkiRich), but I don't have the bandwidth/time to have it upload 40MB saves all the time, so I don't care.
This also blocks a couple functions that list steam friends/blocked users.

You can also copy and paste Script.lua into one of my AssetsRevision.lua mods to have it set before any mods load.

I'm still not sure why a mod should need to access any of this info...


Also: https://www.reddit.com/r/SurvivingMars/comments/91b1xi/psa_this_game_contains_spyware_called_buffpanel/e2x1h18/]],
})