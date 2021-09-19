-- See LICENSE for terms

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
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

--~ SolarPanel.entity == "SolarPanelBig"
--~ SolarPanel.entity == "SolarPanel"

local classes = {
	SolarPanel = true,
	StirlingGenerator = true,
	AdvancedStirlingGenerator = true,
}

local orig_RequiresMaintenance_AccumulateMaintenancePoints = RequiresMaintenance.AccumulateMaintenancePoints
function RequiresMaintenance:AccumulateMaintenancePoints(new_points, ...)
	if not mod_EnableMod then
		return orig_RequiresMaintenance_AccumulateMaintenancePoints(self, new_points, ...)
	end

	if classes[self.class] and IsValid(self.parent_dome) then
		new_points = floatfloor((new_points + 0.0) * mod_PercentAllowed)
		-- just in case
		if new_points < 0 then
			new_points = 0
		end
	end

	return orig_RequiresMaintenance_AccumulateMaintenancePoints(self, new_points, ...)
end
