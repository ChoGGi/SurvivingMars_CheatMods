-- See LICENSE for terms

local function FindTemplateLate(template, key, value)
	local idx = table.find(template, key, value)
	if idx then
		return template[idx]
	end
end

-- add track name
function OnMsg.ClassesPostprocess()
	local template = FindTemplateLate(XTemplates.HUD[1], "Id", "idBottom")
	if not template then
		return
	end

	if template.ChoGGi_ShowMusicTrack_addedtext then
		return
	end
	template.ChoGGi_ShowMusicTrack_addedtext = true

	template = FindTemplateLate(template, "Id", "idRight")
	if not template then
		return
	end
	template = template[1] -- xframe?

	template = FindTemplateLate(template, "Id", "idRadio")
	if not template then
		return
	end

	local ChoOrig_text = template.RolloverText
	template.RolloverText = T{"<ChoOrig_text><newline><newline><playing>: <color 200 200 150><track></color>",
		ChoOrig_text = ChoOrig_text,
		playing = T(1020--[[Playing]]),
		track = function()
			local path = Music.Track and Music.Track.path
			if path then
				local underscore = path:find("_")
				if underscore then
					return path:sub(underscore + 1)
				else
					return path
				end
			else
				return T(130--[[N/A]])
			end
		end,
	}
end

-- add right-click (adding it to template is ignored by something, so I'll be lazy too)
function OnMsg.InGameInterfaceCreated()
	local hud = Dialogs.HUD
	if not hud then
		return
	end
	local radio = hud.idRadio

	local temp_radio_thread

	radio.AltPress = true
	radio.OnAltPress = function()
		if not ActiveRadioStation then
			return
		end

		local station = RadioStationPresets[GetStoredRadioStation()]
		if not station then
			return
		end

		local _, _, _, track_list = GetSortedSoundFiles(station:GetTracksFolder())
		-- Remove host talking
		local mostly_music = table.ifilter(track_list, function(_, value)
			if value:find("Talks_") then
				return
			end
			return true
		end)

		DeleteThread(temp_radio_thread)

		temp_radio_thread = CreateRealTimeThread(function()
			PlayTrack(mostly_music, 1 + AsyncRand(#mostly_music), station.silence * 1000)
		end)

	end

end
