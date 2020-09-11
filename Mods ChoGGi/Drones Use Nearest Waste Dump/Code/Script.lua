-- See LICENSE for terms

local MapFilter = MapFilter
local IsValid = IsValid

local obj_pos
local function SortDist2D(a, b)
	return a:GetDist2D(obj_pos) < b:GetDist2D(obj_pos)
end
local table_sort = table.sort

local orig_TaskRequestHub_FindDemandRequest = TaskRequestHub.FindDemandRequest
function TaskRequestHub:FindDemandRequest(obj, resource, amount, ...)
	-- we only care about WasteRock
	if resource ~= "WasteRock" then
		return orig_TaskRequestHub_FindDemandRequest(self, obj, resource, amount, ...)
	end
	-- If it isn't a dumpsite abort
	local dropoff = obj.d_request and obj.d_request:GetBuilding()
	if IsValid(dropoff) and not dropoff:IsKindOf("WasteRockDumpSite") then
		return orig_TaskRequestHub_FindDemandRequest(self, obj, resource, amount, ...)
	end

	-- Ignore picked up from same obj
	local pickup_obj_bld = obj.picked_up_from_req and obj.picked_up_from_req:GetBuilding()
	if not IsValid(pickup_obj_bld) then
		pickup_obj_bld = nil
	end

	-- filter hub list of connected buildings for dumpsite with free slots and storage space remaining
	local sites = MapFilter(self.connected_task_requesters, function(obj)
		return obj ~= pickup_obj_bld and obj:IsKindOf("WasteRockDumpSite") and obj.has_free_landing_slots
			and (obj.max_amount_WasteRock - obj:GetStored_WasteRock()) >= amount
	end)

	-- not sure what happens when two drones go to the same site and one of them takes the last spot/fills it up?
	-- hopefully whatever happens happens lower then this :)

	-- no site means abort
	if #sites == 0 then
		return orig_TaskRequestHub_FindDemandRequest(self, obj, resource, amount, ...)
	end

	-- sort by dist to drone
	obj_pos = obj:GetVisualPos()
	table_sort(sites, SortDist2D)
	return sites[1].demand.WasteRock

end
