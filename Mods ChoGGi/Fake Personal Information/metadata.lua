return PlaceObj("ModDef", {
	"title", "Fake Personal Information v0.1",
	"version", 1,
	"saved", 1532347200,
	"id", "ChoGGi_FakePersonalInformation",
	"author", "ChoGGi",
	"code", {"Script.lua"},
	"image", "Preview.png",
--~ 	"steam_id", "0",
	"description", [[I don't care for a game storing my personal information.
This changes all your stored info to the info for Haemimont Games and/or the CEO (thanks Google).

This changes g_ParadoxHashedUserId... Which might be used for cloud saves, but I don't have the bandwidth/time to have it upload 40MB saves all the time, so I don't care.
This also blocks a couple functions that list steam friends/blocked users.

You can also copy and paste Script.lua into one of my AssetsRevision.lua mods to have it set before any mods load.

I'm still not sure why a mod should need to access any of this info...]],
})