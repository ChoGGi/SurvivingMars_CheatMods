-- See LICENSE for terms

local SetConstsG = ChoGGi.ComFuncs.SetConstsG

local GetRealm = GetRealm
local IsValid = IsValid

local mod_EnableMod
local mod_StorageAmount
local mod_WorkTime
local mod_WasteRock

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
OnMsg.CityStart = UpdateTransports
OnMsg.LoadGame = UpdateTransports

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_StorageAmount = CurrentModOptions:GetProperty("StorageAmount") * const.ResourceScale
	mod_WorkTime = CurrentModOptions:GetProperty("WorkTime") * const.ResourceScale
	mod_WasteRock = CurrentModOptions:GetProperty("WasteRock")

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


-- the orig heads back to dump if you have any space used up, I think filling up first is better
local ChoOrig_RCTransport_ProcAutomation = RCTransport.ProcAutomation
function RCTransport:ProcAutomation(...)
	if not mod_EnableMod then
		return ChoOrig_RCTransport_ProcAutomation(self, ...)
	end

--~ 	if self:GetStoredAmount() <= 0 then

	-- if there's room and there's something to pickup then grab it
	if self:GetStoredAmount() < self.max_shared_storage and self:ChoGGi_GetNearestStockpile() then
		self:Automation_Gather()
	else
		self:Automation_Unload()
	end

	Sleep(2500)
end

function RCTransport:ChoGGi_GetNearestStockpile()
	-- check for waste rock or only regular res
	local wasterock_cls = mod_WasteRock and "WasteRockStockpileUngrided"

	local unreachable_objects = self:GetUnreachableObjectsTable()
	return GetRealm(self):MapFindNearest(
		self, "map", "ResourceStockpile", wasterock_cls, function(stockpile)
--~ 		self, "map", "ResourceStockpile", function(stockpile)
			-- skip anything in range of drones
			local depot_temp = #(stockpile.command_centers or "") == 0
				-- and don't grab from depots connected to building
				and not IsValid(stockpile:GetParent()) and stockpile

			if depot_temp and (depot_temp.auto_rovers or 0) >= max_auto_rovers_per_pickup then
				return false
			end
			return depot_temp and not unreachable_objects[depot_temp] and not depot_temp:GetParent()
		end
	)

end

local ChoOrig_RCTransport_Automation_Gather = RCTransport.Automation_Gather
function RCTransport:Automation_Gather(...)
	if not mod_EnableMod then
		return ChoOrig_RCTransport_Automation_Gather(self, ...)
	end

	local depot = self:ChoGGi_GetNearestStockpile()

	--  no stockpiles around, so nothing to do
	if not depot then
		return ChoOrig_RCTransport_Automation_Gather(self, ...)
	end


	if depot then
		local path_pos = self:HasPath(depot, self.work_spot_deposit)
		if path_pos then
			depot.auto_rovers = (depot.auto_rovers or 0) + 1
			self:PushDestructor(function(self)
				depot.auto_rovers = depot.auto_rovers - 1
				if depot.auto_rovers < 0 then
					depot.auto_rovers = 0
				end
			end)
			Sleep(250)

			local commandf = GetCommandFunc(self)
			commandf(self, "PickupResource", depot.supply_request, nil, "goto_loading_complete")
		else
			local unreachable_objects = self:GetUnreachableObjectsTable()
			unreachable_objects[depot] = true
		end
	end

end

local ChoOrig_RCTransport_DumpCargo = RCTransport.DumpCargo
function RCTransport:DumpCargo(pos, resource, ...)
	local stockpile = ChoOrig_RCTransport_DumpCargo(self, pos, resource, ...)

	-- hopefully this fixes the loopy
	if IsValid(stockpile) then
		local unreachable_objects = self:GetUnreachableObjectsTable()
		unreachable_objects[stockpile] = true


	end

	return stockpile
end
-- onmsg new day clear any depot auto_rovers/invalid task_requests?