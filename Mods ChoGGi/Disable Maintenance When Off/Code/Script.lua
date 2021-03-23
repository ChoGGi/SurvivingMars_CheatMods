-- See LICENSE for terms

local mod_QuarterPoints

-- fired when settings are changed/init
local function ModOptions()
	mod_QuarterPoints = CurrentModOptions:GetProperty("QuarterPoints")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

local orig_RequiresMaintenance_SetMalfunction = RequiresMaintenance.SetMalfunction
function RequiresMaintenance:SetMalfunction(...)
	if self.accumulated_maintenance_points => self.maintenance_threshold_current then
		return orig_RequiresMaintenance_SetMalfunction(self, ...)
	end
end

local orig_RequiresMaintenance_AccumulateMaintenancePoints = RequiresMaintenance.AccumulateMaintenancePoints
function RequiresMaintenance:AccumulateMaintenancePoints(new_points, ...)
	if not self.ui_working then
		if mod_QuarterPoints then
			new_points = new_points / 4
			if new_points < 0 then
				new_points = 0
			end
		else
			new_points = 0
		end
	end
	return orig_RequiresMaintenance_AccumulateMaintenancePoints(self, new_points, ...)
end
