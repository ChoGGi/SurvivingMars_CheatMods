-- See LICENSE for terms

--~ do return end

local GetRealm = GetRealm
local FindNearestObject = FindNearestObject

local Random = ChoGGi.ComFuncs.Random
local SetConstsG = ChoGGi.ComFuncs.SetConstsG

local mod_EnableMod
local mod_StorageAmount
local mod_WorkTime
local mod_WasteRock

-- transport is going for this stockpile
GlobalVar("g_ChoGGi_RCTransportCheats_usedstocks", false)

-- ergh
local function ClearUsedStocks()
	table.clear(g_ChoGGi_RCTransportCheats_usedstocks)
end

local function UpdateTransports()
	if not mod_EnableMod then
		return
	end

	if not g_ChoGGi_RCTransportCheats_usedstocks then
		g_ChoGGi_RCTransportCheats_usedstocks = {}
	end

	ClearUsedStocks()

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

function RCTransport:ChoGGi_GetStockpile(res_type)
	local g_ChoGGi_RCTransportCheats_usedstocks = g_ChoGGi_RCTransportCheats_usedstocks
	local unreachable_objects = self:GetUnreachableObjectsTable()

	return GetRealm(self):MapFindNearest(
		self, "map", res_type, function(stockpile)
			-- can't get there
			if unreachable_objects[stockpile]
				-- in range of drone controller
				or #(stockpile.command_centers or "") > 0
				-- someone else is going for it
				or g_ChoGGi_RCTransportCheats_usedstocks[stockpile]
				-- attached to a building
				or stockpile:GetParent()
			then
				return false
			end

			return stockpile
		end
	)
end

function RCTransport:ChoGGi_GetNearestStockpile()
	local stocks = {}

	stocks[1] = self:ChoGGi_GetStockpile("ResourceStockpile")
	-- Check for waste rock or only regular res
	if mod_WasteRock then
		stocks[2] = self:ChoGGi_GetStockpile("WasteRockStockpileUngrided")
	end

	if stocks[2] then
		return FindNearestObject(stocks, self)
	else
		return stocks[1]
	end

	return false
end

-- Look for depots to use
local ChoOrig_RCTransport_Automation_Gather = RCTransport.Automation_Gather
function RCTransport:Automation_Gather(...)
	if not mod_EnableMod then
		return ChoOrig_RCTransport_Automation_Gather(self, ...)
	end

	-- More natural hopefully
	Sleep(Random(4000))

	local depot = self:ChoGGi_GetNearestStockpile()

	--  No stockpiles around, so nothing to do
	if not depot then
		return ChoOrig_RCTransport_Automation_Gather(self, ...)
	end

	if depot then
		-- Can rc get to depot
		if self:HasPath(depot, self.work_spot_deposit) then
			-- Try to get other transports ignore it for awhile
			g_ChoGGi_RCTransportCheats_usedstocks[depot] = self

			self:SetCommand("PickupResource", depot.supply_request, nil, "goto_loading_complete")
		else
			self:GetUnreachableObjectsTable()[depot] = true
		end
	end

end

-- Reset the storage override list (I only have it so they all don't spam rush the first one)
local ChoOrig_RCTransport_DumpCargo = RCTransport.DumpCargo
function RCTransport.DumpCargo(...)
	if not mod_EnableMod then
		return ChoOrig_RCTransport_DumpCargo(...)
	end

	ClearUsedStocks()
	return ChoOrig_RCTransport_DumpCargo(...)
end

-- Clear rover storages with ghost resources
--~ function OnMsg.NewHour()
function OnMsg.LightmodelChange()
	if not mod_EnableMod or not UIColony then
		return
	end

	local objs = UIColony:GetCityLabels("RCTransportAndChildren")
	for i = 1, #objs do
		local obj = objs[i]
		if obj:GetAttaches("ResourceStockpileBox") and obj:GetStoredAmount() == 0 then
			obj:DestroyAttaches("ResourceStockpileBox")
		end
	end

end
