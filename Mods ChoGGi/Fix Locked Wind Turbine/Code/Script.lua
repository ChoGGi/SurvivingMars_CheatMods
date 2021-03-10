-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	local o = BuildMenuPrerequisiteOverrides

	if o.WindTurbine and TGetID(o.WindTurbine) == 401896326435 --[[You can't construct this building at this time]] then
		o.WindTurbine = nil
	end
end

