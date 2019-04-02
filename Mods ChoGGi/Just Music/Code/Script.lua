-- See LICENSE for terms

local orig_PlayTrack = PlayTrack
function PlayTrack(track_list, index, silence, ...)
	-- skip the non-music track lists
	local track = track_list[1]
	if track and (track:find("_Blurb_") or track:find("_Talks_") or track:find("_Commercials_")) then
		return #track_list
	end
	-- it's all good
	return orig_PlayTrack(track_list, index, silence, ...)
end
