-- See LICENSE for terms

local SetConstsG = ChoGGi.ComFuncs.SetConstsG

local GetRealm = GetRealm
local IsValid = IsValid

local mod_EnableMod
local mod_StorageAmount
local mod_WorkTime

local function UpdateTransports()
	if not mod_EnableMod then
		return
	end

	SetConstsG("RCTransportGatherResourceWorkTime", mod_WorkTime)

	if mod_StorageAmount > 0 then
		local objs = UIColony:GetCityLabels("RCTransportAndChildren")
		for i = 1, #objs do
			objs[i].max_shared_storage = mod_StorageAmount
		end
	end
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_StorageAmount = CurrentModOptions:GetProperty("StorageAmount") * const.ResourceScale
	mod_WorkTime = CurrentModOptions:GetProperty("WorkTime") * const.ResourceScale

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	UpdateTransports()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_RCTransport_Automation_Gather = RCTransport.Automation_Gather
function RCTransport:Automation_Gather(...)
	if not mod_EnableMod then
		return ChoOrig_RCTransport_Automation_Gather(self, ...)
	end

	local unreachable_objects = self:GetUnreachableObjectsTable()
	local depot = GetRealm(self):MapFindNearest(self, "map", "ResourceStockpile",
		function(d)
		-- skip anything in range of drones
		local depot = #(d.command_centers or "") == 0
			-- and don't grab from depots connected to building
			and not IsValid(d:GetParent()) and d

		if depot and (depot.auto_rovers or 0) >= max_auto_rovers_per_pickup then
			return false
		end
		return depot and not unreachable_objects[depot]
	end)
	--  no stockpiles around, so nothing to do
	if not depot then
		return ChoOrig_RCTransport_Automation_Gather(self, ...)
	end

	if depot then
		if self:HasPath(depot, self.work_spot_deposit) then
			depot.auto_rovers = (depot.auto_rovers or 0) + 1
			self:PushDestructor(function(self)
				depot.auto_rovers = depot.auto_rovers - 1
			end)
			self:SetCommand("PickupResource", depot.task_requests[#depot.task_requests], nil, "goto_loading_complete")
		else
			unreachable_objects[depot] = true
		end
	end
end