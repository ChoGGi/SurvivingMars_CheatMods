-- See LICENSE for terms

function OnMsg.ClassesPostprocess()

	PlaceObj("RadioStationPreset", {
		display_name = T(302535920011404, "Custom Music"),
		folder = "AppData/Music",
		group = "Default",
		id = "Custom_Music_FTW",
		silence = 1,
	})

end
