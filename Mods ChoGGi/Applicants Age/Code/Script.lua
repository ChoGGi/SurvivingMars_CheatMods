-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

function OnMsg.NewDay() -- NewSol...
	if not mod_EnableMod or not g_LastGeneratedApplicantTime then
		return
	end

	local g_ApplicantPool = g_ApplicantPool
	for i = 1, #g_ApplicantPool do
		local applicant = g_ApplicantPool[i][1]
		applicant.age = applicant.age + 1
	end

end
