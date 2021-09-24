-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
OnMsg.ModsReloaded = ModOptions
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_Challenge_GetCompletedText = Challenge.GetCompletedText
function Challenge:GetCompletedText(...)
	if not mod_EnableMod then
		return ChoOrig_Challenge_GetCompletedText(self, ...)
	end

  local completed = self:Completed()

	local text
  if completed and completed.time < self.time_perfected then
    text = T{10919, "<newline>Perfected in <sols> Sols",
      sols = 1 + completed.time / const.DayDuration,
    }
  elseif completed then
    text = T{10920, "<newline>Completed in <sols> Sols",
      sols = 1 + completed.time / const.DayDuration,
    }
  end
	-- append score to completed text
	if text then
		return text .. T{302535920012039, "\nScore: <score>",
			score = completed.score
		}
	end

  return ""
end

--~ local temp_chall = {time_completed = max_int}
--~ temp_chall.id = "TerraformingBreathableAtmosphere"
--~ Challenge.Completed(temp_chall)
