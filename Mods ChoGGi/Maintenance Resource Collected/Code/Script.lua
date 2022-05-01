-- See LICENSE for terms

local r = const.ResourceScale
local tag = const.TagLookupTable
local type = type

local ChoOrig_GetMaintenanceRolloverText = RequiresMaintenance.GetMaintenanceRolloverText
function RequiresMaintenance:GetMaintenanceRolloverText(...)
	local text = ""
	local req = self.maintenance_resource_request

	if req and type(req) == "userdata" then
		text = T{"\n\n<res> <icon>: <amount1>/<amount2>",
			res = T(840,"Resources:"),
			icon = tag["icon_" .. req:GetResource()],
			amount1 = req:GetActualAmount() / r,
			amount2 = self.maintenance_resource_amount / r,
		}
	end

	return ChoOrig_GetMaintenanceRolloverText(self, ...) .. text
end
