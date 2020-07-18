-- See LICENSE for terms

local mod_ApplicantAmount

-- fired when settings are changed/init
local function ModOptions()
	mod_ApplicantAmount = CurrentModOptions:GetProperty("ApplicantAmount")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local GenerateApplicant = GenerateApplicant

function OnMsg.ColonistLeavingMars(colonist)
	if colonist.traits.Tourist and mod_ApplicantAmount > 2 then
		-- Colonist:LeavingMars() always adds two.
		for _ = 1, (mod_ApplicantAmount - 2) do
			GenerateApplicant(false, colonist.city).traits.Tourist = true
		end
	end
end