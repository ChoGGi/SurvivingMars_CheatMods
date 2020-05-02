-- See LICENSE for terms

local MapFilter = MapFilter
local FindNearestObject = FindNearestObject

local orig_TaskRequestHub_FindDemandRequest = TaskRequestHub.FindDemandRequest
function TaskRequestHub:FindDemandRequest(obj, resource, amount, ...)
	-- we only care about WasteRock
	if resource ~= "WasteRock" then
		return orig_TaskRequestHub_FindDemandRequest(self, obj, resource, amount, ...)
	end

	-- filter hub list of connected buildings for dumpsite with free slots and storage space remaining
	local sites = MapFilter(self.connected_task_requesters, function(obj)
		return (
			obj:IsKindOf("WasteRockDumpSite") and obj.has_free_landing_slots
				and (obj.max_amount_WasteRock - obj:GetStored_WasteRock()) >= amount
		) or (
			obj:IsKindOf("WasteRockProcessor")
				and (obj.max_storage - obj:GetWasterockAmountStored()) >= amount
		)
	end)

	-- not sure what happens when two drones go to the same site and one of them takes the last spot/fills it up?
	-- hopefully whatever happens happens lower then this :)

	if #sites > 0 then
		return FindNearestObject(sites, obj).demand.WasteRock
	end
end
