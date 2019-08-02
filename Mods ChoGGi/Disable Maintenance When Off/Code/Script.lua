-- See LICENSE for terms

local orig_AccumulateMaintenancePoints = RequiresMaintenance.AccumulateMaintenancePoints
function RequiresMaintenance:AccumulateMaintenancePoints(...)
	if not self.working then
		return
	end
	return orig_AccumulateMaintenancePoints(self, ...)
end
