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

function OnMsg.LoadGame()
	if not mod_EnableMod then
		return
	end

	local o = BuildMenuPrerequisiteOverrides

	if o.WindTurbine and TGetID(o.WindTurbine) == 401896326435 --[[You can't construct this building at this time]] then
		o.WindTurbine = nil
	end
end

