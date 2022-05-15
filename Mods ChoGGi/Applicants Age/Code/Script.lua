-- See LICENSE for terms

local mod_EnableMod
local mod_MaxAge

-- fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_MaxAge = CurrentModOptions:GetProperty("MaxAge")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.NewDay() -- NewSol...
	if not mod_EnableMod or not g_LastGeneratedApplicantTime then
		return
	end

	local const = const
	local g_ApplicantPool = g_ApplicantPool
	-- going backwards if applicants are removed
	for i = #g_ApplicantPool, 1, -1 do
		local applicant = g_ApplicantPool[i][1]
		applicant.age = applicant.age + 1
		-- too old for mars
		if mod_MaxAge > 0 and applicant.age >= mod_MaxAge then
			table.remove(g_ApplicantPool, i)
		else
			-- bump age_trait if needed
			local age_trait = applicant.age_trait
			local agegroup = const.ColonistAgeGroups[age_trait]
			if applicant.age >= agegroup.min and agegroup.next_agegroup then
				applicant.age_trait = agegroup.next_agegroup
				applicant.traits[age_trait] = nil
				applicant.traits[agegroup.next_agegroup] = true
			end
		end
	end
end
