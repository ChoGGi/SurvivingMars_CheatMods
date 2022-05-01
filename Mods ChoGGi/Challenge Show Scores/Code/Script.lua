-- See LICENSE for terms

local mod_EnableMod

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

local ChoOrig_Challenge_GetCompletedText = Challenge.GetCompletedText
function Challenge:GetCompletedText(...)
	if not mod_EnableMod then
		return ChoOrig_Challenge_GetCompletedText(self, ...)
	end

  local completed = self:Completed()
	if completed then
		local text = T{0, "<chal_text>: <time(time)>",
			chal_text = "",
			time = completed.time,
		}
		if completed.time < self.time_perfected then
			text.chal_text = T(10325, "Challenge Perfected")
		elseif completed then
			text.chal_text = T(10321, "Challenge Completed")
		end

		return text .. T{302535920012039, "\nScore: <score>",
			score = completed.score
		}
	end

  return ""
end

--~ local temp_chall = {time_completed = max_int}
--~ temp_chall.id = "TerraformingBreathableAtmosphere"
--~ Challenge.Completed(temp_chall)
