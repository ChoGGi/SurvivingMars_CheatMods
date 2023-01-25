-- See LICENSE for terms

local floatfloor = floatfloor

local mod_EnableMod
local mod_PercentAllowed

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	-- needs 0.0 or it'll always be 0
	mod_PercentAllowed = (CurrentModOptions:GetProperty("PercentAllowed") + 0.0) / 100

end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_RequiresMaintenance_AccumulateMaintenancePoints = RequiresMaintenance.AccumulateMaintenancePoints
function RequiresMaintenance:AccumulateMaintenancePoints(new_points, ...)
	-- We only care about points being added, not tribby removing them
	if not mod_EnableMod or new_points < 1 then
		return ChoOrig_RequiresMaintenance_AccumulateMaintenancePoints(self, new_points, ...)
	end

	new_points = floatfloor((new_points + 0.0) * mod_PercentAllowed)
	-- Just in case
	if new_points < 0 then
		new_points = 0
	end

	return ChoOrig_RequiresMaintenance_AccumulateMaintenancePoints(self, new_points, ...)
end
