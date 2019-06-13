-- See LICENSE for terms

local r = const.ResourceScale
local tag = const.TagLookupTable
local type = type

local orig_GetMaintenanceRolloverText = RequiresMaintenance.GetMaintenanceRolloverText
function RequiresMaintenance:GetMaintenanceRolloverText(...)
	local text = ""

	local req = self.maintenance_resource_request
	if req and type(req) == "userdata" then
		local icon = tag["icon_" .. req:GetResource()]
		text = "\n\n" .. T(840,"Resources:") .. " " .. icon .. ": "
			.. req:GetActualAmount() / r .. "/" .. self.maintenance_resource_amount / r
	end

	return orig_GetMaintenanceRolloverText(self, ...) .. text
end
