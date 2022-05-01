-- See LICENSE for terms

local GenerateApplicant = GenerateApplicant

local mod_ApplicantAmount

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_ApplicantAmount = CurrentModOptions:GetProperty("ApplicantAmount")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.ColonistLeavingMars(colonist)
	if colonist.traits.Tourist and mod_ApplicantAmount > 2 then
		-- Colonist:LeavingMars() always adds two.
		for _ = 1, (mod_ApplicantAmount - 2) do
			GenerateApplicant(false, colonist.city).traits.Tourist = true
		end
	end
end