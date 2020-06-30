-- See LICENSE for terms

local orig_AccumulateMaintenancePoints = RequiresMaintenance.AccumulateMaintenancePoints
function RequiresMaintenance:AccumulateMaintenancePoints(new_points, ...)
	if not self.working then
		new_points = 0
	end
	return orig_AccumulateMaintenancePoints(self, new_points, ...)
end
