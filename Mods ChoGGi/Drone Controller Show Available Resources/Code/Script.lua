-- See LICENSE for terms

local table = table
local string_lower = string.lower

local res_count = {}
local res_str, res_str_c = {}, 0
local res_list, res_list_c

local function GetAvailableResources(self)
	if not res_list then
		res_list = AllResourcesList
		res_list_c = #res_list
		table.sort(res_list)
	end
	-- reset to 0
	for i = 1, res_list_c do
		res_count[res_list[i]] = 0
	end

	local supply_queues = self.supply_queues
	local objs = self.connected_task_requesters or ""
	for i = 1, #objs do
		local obj = objs[i]
		-- factory storage depots
		if obj:IsKindOf("ResourceStockpile") then
			res_count[obj.resource] = res_count[obj.resource] + obj.stockpiled_amount
		-- storage depots/rockets/wasterock
		elseif obj:IsKindOf("StorageDepot") then
			local resources = obj.resource or ""
			for j = 1, #resources do
				local r = resources[j]
				if r then
					res_count[r] = res_count[r] + (obj["GetStored_" .. r](obj) or 0)
				-- wasterock site
				elseif obj.resource then
					res_count[obj.resource] = res_count[obj.resource] + obj.total_stockpiled
				end
			end
		end
	end

	table.iclear(res_str)
	res_str_c = 0

	for i = 1, res_list_c do
		local res = res_list[i]
		local count = res_count[res]
		if count > 0 then
			res_str_c = res_str_c + 1
			res_str[res_str_c] = T{
				"<newline><left><resource(res)><right><" .. string_lower(res) .. "(count)>",
				res = res,
				count = count,
			}
		end
	end
--~ 	ex(res_str)

	return table.concat(res_str)
end

RCRover.ChoGGi_GetAvailableResources = GetAvailableResources
SupplyRocket.ChoGGi_GetAvailableResources = GetAvailableResources
DroneHub.ChoGGi_GetAvailableResources = GetAvailableResources

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.sectionServiceArea[1]
	if xtemplate.ChoGGi_Added_DroneControllerShowAvailableResources then
		return
	end
	xtemplate.ChoGGi_Added_DroneControllerShowAvailableResources = true

	xtemplate.RolloverText = xtemplate.RolloverText .. T("<newline><ChoGGi_GetAvailableResources>")
end
