-- See LICENSE for terms

local mod_QuarterPoints

-- fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_QuarterPoints = CurrentModOptions:GetProperty("QuarterPoints")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions


-- 		{template = true, category = "Maintenance", name = T(128, "Disable Maintenance"),        id = "disable_maintenance", no_edit = true, modifiable = true, editor = "number", default = 0, help = "So maintenance can be turned off with modifiers"},




local ChoOrig_RequiresMaintenance_AccumulateMaintenancePoints = RequiresMaintenance.AccumulateMaintenancePoints
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
	return ChoOrig_RequiresMaintenance_AccumulateMaintenancePoints(self, new_points, ...)
end
