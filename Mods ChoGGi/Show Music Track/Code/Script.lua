-- See LICENSE for terms

local function FindTemplateLate(template, key, value)
	local idx = table.find(template, key, value)
	if idx then
		return template[idx]
	end
end

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
	template = template[1]

	template = FindTemplateLate(template, "Id", "idRadio")
	if not template then
		return
	end

	local orig_text = template.RolloverText
	template.RolloverText = T{"<orig_text><newline><newline><playing>: <track>",
		orig_text = orig_text,
		playing = T(1020, "Playing"),
		track = function()
			local path = Music.Track and Music.Track.path
			if path then
				local underscore = path:reverse():find("_")
				if underscore then
					return path:sub(-underscore + 1)
				else
					return path
				end
			else
				return T(130, "N/A")
			end
		end,
	}

end
