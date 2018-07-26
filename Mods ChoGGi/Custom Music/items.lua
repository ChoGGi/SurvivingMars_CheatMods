--[[
Place files in AppData/Surviving Mars/Music
As far as I know it only plays opus and wav
mp3,aac,ogg,flac,aiff = don't work

Spaces and what not in names are a-ok

test if music format works
PlaySound("AppData/Music/some filename.ext","Music") --"Music", "UI"
--]]

-- local some globals for slightly faster access
local table = table
local Music,WaitMsg,Sleep,AsyncRand = Music,WaitMsg,Sleep,AsyncRand

local delay_between_tracks = 1 -- seconds

return {
  PlaceObj("ModItemRadioStation", {
    "name", "CustomMusic",
    "display_name",[[Custom Music]],
    "play", function (self)
      -- only list opus files
--~       local err, files = AsyncListFiles("AppData/Music",".opus")
      -- list all files in folder
      local err, files = AsyncListFiles("AppData/Music")
      if err or #files < 1 then
        CreateRealTimeThread(WaitCustomPopupNotification,
          [[Custom Music Help]],
          [[Place files in AppData/Surviving Mars/Music.
As far as I know it only plays opus and wav.]],
          {"OK"}
        )
        return
      end
      while true do
        -- remove this line if you want to play in file name order
        table.permute(files, AsyncRand())
        -- loop through all the files
        for i = 1, #files do
          -- you could add a
          -- if files[i]:find(".opus") or files[i]:find(".wav") then
          -- end
          -- if you want to only play certain file types
          Music:PlayTrack({path = files[i]})
          -- wait till it ends, or at most 30 minutes
          WaitMsg("MusicTrackEnded", 30*60*1000)
          -- pause between tracks
          Sleep(delay_between_tracks * 1000)
        end
      end
    end,
  })
}
