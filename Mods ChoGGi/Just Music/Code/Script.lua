-- See LICENSE for terms

local mod_SkipBlurbs
local mod_SkipTalks
local mod_SkipCommercials

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	mod_SkipBlurbs = options:GetProperty("SkipBlurbs")
	mod_SkipTalks = options:GetProperty("SkipTalks")
	mod_SkipCommercials = options:GetProperty("SkipCommercials")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_PlayTrack = PlayTrack
function PlayTrack(track_list, index, silence, ...)
	-- skip the non-music track lists
	local track = track_list[1]
	if track then
		-- can be list of string or list of table>string
		local track_type = type(track)
		track = track_type == "string" and track or
			track_type == "table" and track[1]

		if track:find("_Blurb_") and mod_SkipBlurbs or
			track:find("_Talks_") and mod_SkipTalks or
			track:find("_Commercials_") and mod_SkipCommercials
		then
			Msg("MusicTrackEnded")
			return index + 1
		end
	end

	-- It's all good
	return ChoOrig_PlayTrack(track_list, index, silence, ...)
end

