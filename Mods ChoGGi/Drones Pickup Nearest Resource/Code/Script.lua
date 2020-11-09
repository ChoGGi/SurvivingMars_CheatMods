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

local RetNearestResourceDepot = ChoGGi.ComFuncs.RetNearestResourceDepot

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
