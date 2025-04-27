-- See LICENSE for terms

local table = table

local mod_EnableMod

local ChoOrig_GetSortedSoundFiles = GetSortedSoundFiles
function GetSortedSoundFiles(folder, ...)
	if not mod_EnableMod or folder ~= "Music/Red Frontier" then
		return ChoOrig_GetSortedSoundFiles(folder, ...)
	end

	local blurbs, talks, commercials, music = ChoOrig_GetSortedSoundFiles(folder, ...)
	local blurbsu, talksu, commercialsu, musicu = ChoOrig_GetSortedSoundFiles("AppData/Music", ...)
	table.iappend(blurbs, blurbsu)
	table.iappend(talks, talksu)
	table.iappend(commercials, commercialsu)
	table.iappend(music, musicu)
	table.shuffle(music)

	return blurbs, talks, commercials, music
end

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
