return {
--[[
Place files in AppData/Surviving Mars/Music
As far as I know it only plays opus and wav
mp3,aac,ogg,flac,aiff = don't work

Spaces and what not in names are a-ok

test if music format works
PlaySound("AppData/Music/some filename.ext","Music") --"Music", "UI"
--]]
PlaceObj('ModItemRadioStation', {
	'name', "CustomMusic",
	'display_name',"Custom Music",
	'silence', 1, --seconds between tracks
	'play', function (self)
    local err, files = AsyncListFiles("AppData/Music")
    if err or not next(files) then
      CreateRealTimeThread(WaitCustomPopupNotification,
        "Help",
        "See AppData/CheatMod_CheatMenu/metadata.lua for info on playing custom music.",
        {"OK"}
      )
      return
    end
    while true do
      table.permute(files, AsyncRand())           -- shuffle files list, with random seed
      for _, file in ipairs(files) do
        Music:PlayTrack({ path = file })        -- start playing one track via the music subsystem
        WaitMsg("MusicTrackEnded", 30*60*1000)  -- wait till it ends, or at most 30 minutes
        Sleep(self.silence * 1000)              -- pause for silence
      end
    end
  end,
}),

}
