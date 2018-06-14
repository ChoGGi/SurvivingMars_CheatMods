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
    local table = table
    local Music,WaitMsg,Sleep,AsyncRand = Music,WaitMsg,Sleep,AsyncRand

    local err, files = AsyncListFiles("AppData/Music")
    if err or #files < 1 then
      CreateRealTimeThread(WaitCustomPopupNotification,
        "Help",
        "Place files in AppData/Surviving Mars/Music.\nAs far as I know it only plays opus and wav.",
        {"OK"}
      )
      return
    end
    while true do
      table.permute(files, AsyncRand())           -- shuffle files list, with random seed
      for i = 1, #files do
        Music:PlayTrack({path = files[i]})        -- start playing one track via the music subsystem
        WaitMsg("MusicTrackEnded", 30*60*1000)  -- wait till it ends, or at most 30 minutes
        Sleep(self.silence * 1000)              -- pause for silence
      end
    end
  end,
}),

}
