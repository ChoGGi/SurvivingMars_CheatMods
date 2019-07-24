-- See LICENSE for terms

local HourDuration = const.HourDuration
local time_str = {12265, "Remaining Time<right><time(time)>"}

local orig_GetMaintenanceRolloverText = RequiresMaintenance.GetMaintenanceRolloverText
function RequiresMaintenance:GetMaintenanceRolloverText(...)
	local hours = (
		self.maintenance_threshold_current - self.accumulated_maintenance_points
	) / self.maintenance_build_up_per_hr

	time_str.time = hours * HourDuration
	return orig_GetMaintenanceRolloverText(self, ...) .. T("\n<left>") .. T(time_str)
end
