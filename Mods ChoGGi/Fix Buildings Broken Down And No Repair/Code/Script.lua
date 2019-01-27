-- See LICENSE for terms

local type = type
local table = table

function OnMsg.LoadGame()
	local blds = UICity.labels.Building or ""
	for i = 1, #blds do
		local bld = blds[i]

		-- clear out non-task requests in task_requests
		local task_requests = bld.task_requests or ""
		for j = #task_requests, 1, -1 do
			local req = task_requests[j]
			if type(req) ~= "userdata" then
				table.remove(task_requests,j)
			end
		end

		if not bld.maintenance_resource_request and bld:DoesMaintenanceRequireResources() then
			-- restore main res request
			local resource_unit_count = 1 + (bld.maintenance_resource_amount / (const.ResourceScale * 10)) --1 per 10
			local r_req = bld:AddDemandRequest(bld.maintenance_resource_type, 0, 0, resource_unit_count)
			bld.maintenance_resource_request = r_req
			bld.maintenance_request_lookup[r_req] = true
			-- needs to be fired off to complete the reset?
			bld:SetExceptionalCircumstancesMaintenance(bld.maintenance_resource_type, 1)
			bld:Setexceptional_circumstances(false)
		end

	end
end