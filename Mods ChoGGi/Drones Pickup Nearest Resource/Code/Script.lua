-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

--~ local RetNearestResourceDepot = ChoGGi.ComFuncs.RetNearestResourceDepot

-- remove when update lib mod
local table_append = table.append
local table_find = table.find
local table_iclear = table.iclear
local FindNearestObject = FindNearestObject
local MapGet = MapGet

local res_funcs = {}
local res_mechdepot = {}
local AllResourcesList = AllResourcesList
for i = 1, #AllResourcesList do
	local res = AllResourcesList[i]
	res_funcs[res] = "GetStored_" .. res
	res_mechdepot[res] = "MechanizedDepot" .. res
end
local GetStored, res_amount, res_resource
local function FilterTable(depot)
	-- check if depot has the resource
	if (depot.resource == res_resource or table_find(depot.resource, res_resource))
		-- check if depot has resource amount
		and depot[GetStored] and depot[GetStored](depot) >= res_amount
	then
		return true
	end
end
local stockpiles_table = {}
local stockpiles
local RetNearestResourceDepot = ChoGGi.ComFuncs.RetNearestResourceDepot or function(resource, obj, list, amount, skip_stocks)
	GetStored = res_funcs[resource] or "GetStored_" .. resource
	res_resource = resource

	if list then
		stockpiles = list
		res_amount = amount
	else
		-- attached stockpiles/stockpiles left from removed objects
		if skip_stocks then
			stockpiles = MapGet("map", "ResourceStockpile", "ResourceStockpileLR")
		else
			stockpiles = stockpiles_table
			table_iclear(stockpiles)
		end
		res_amount = amount or 1000

		local labels = UICity.labels
		-- every resource has a mech depot
		table_append(stockpiles, labels["MechanizedDepot" .. resource])

		if resource == "BlackCube" then
			table_append(stockpiles, labels.BlackCubeDumpSite)
		elseif resource == "MysteryResource" then
			table_append(stockpiles, labels.MysteryDepot)
		elseif resource == "WasteRock" then
			table_append(stockpiles, labels.WasteRockDumpSite)
		else
			-- labels.UniversalStorageDepot includes the "other" depots, but not the above three
			table_append(stockpiles, labels.UniversalStorageDepot)
		end
	end

	return FindNearestObject(stockpiles, obj:GetPos():SetInvalidZ(), FilterTable)
end
-- remove when update lib mod

local skips = {"LandscapeConstructionSiteBase"}

local rfWork = const.rfWork
local orig_TaskRequestHub_FindTask = TaskRequestHub.FindTask
local Request_FindTask = Request_FindTask
function TaskRequestHub:FindTask(agent, ...)
	-- we only care about drones going to pickup resources
	if not mod_EnableMod or not agent then
		return orig_TaskRequestHub_FindTask(self, agent, ...)
	end

	-- from function TaskRequestHub:FindTask(agent)
  self.unreachable_buildings = agent.unreachable_buildings
	local request, pair_request, resource, amount = Request_FindTask(self)

	-- we only want reqs that are Pickups
	if request and not request:IsAnyFlagSet(rfWork) and not request:GetBuilding():IsKindOfClasses(skips) then
		-- find the nearest resource of the same type
		local nearest = RetNearestResourceDepot(resource, agent, self.connected_task_requesters, amount)
		-- change request to use our building instead
		if nearest and nearest.supply and nearest.supply[resource] then
			request = nearest.supply[resource]
		end
	end

	return request, pair_request, resource, amount, ...
end
