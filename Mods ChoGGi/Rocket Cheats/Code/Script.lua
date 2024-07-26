-- See LICENSE for terms

local mod_LaunchFuel
local mod_MaxExportStorage
local mod_PassengerOrbitLifetime
local mod_MaxColonistsPerRocket
local mod_TravelTimeEarthMars
local mod_TravelTimeMarsEarth
local mod_RocketPrice
local mod_CargoCapacity
local mod_FoodPerRocketPassenger
local mod_DustStormFlight

-- DustStormFlight
local ChoOrig_HasDustStorm = HasDustStorm
local ChoFake_HasDustStorm = function()
	return false
end
local function UpdateRocket(func, self, ...)

	local orig_affected = self.affected_by_dust_storm or self.rocket and self.rocket.affected_by_dust_storm
	if self.affected_by_dust_storm then
		self.affected_by_dust_storm = false
	elseif self.rocket and self.rocket.affected_by_dust_storm then
		self.rocket.affected_by_dust_storm = false
	end
	HasDustStorm = ChoFake_HasDustStorm

	local _, ret = pcall(func, self, ...)

	if self.affected_by_dust_storm then
		self.affected_by_dust_storm = orig_affected
	elseif self.rocket and self.rocket.affected_by_dust_storm then
		self.rocket.affected_by_dust_storm = orig_affected
	end
	HasDustStorm = ChoOrig_HasDustStorm
	return ret
end

-- Take off during dust storms
local ChoOrig_RocketBase_GetLaunchIssue = RocketBase.GetLaunchIssue
function RocketBase:GetLaunchIssue(...)
	if not mod_DustStormFlight then
		return ChoOrig_RocketBase_GetLaunchIssue(self, ...)
	end

	return UpdateRocket(ChoOrig_RocketBase_GetLaunchIssue, self, ...)
end
-- Land during dust storms
local ChoOrig_ConstructionController_UpdateConstructionStatuses = ConstructionController.UpdateConstructionStatuses
function ConstructionController:UpdateConstructionStatuses(...)
	if not mod_DustStormFlight then
		return ChoOrig_ConstructionController_UpdateConstructionStatuses(self, ...)
	end

	return UpdateRocket(ChoOrig_ConstructionController_UpdateConstructionStatuses, self, ...)
end

-- Override for custom_travel_time_mars/custom_travel_time_earth
local ChoOrig_RocketBase_FlyToEarth = RocketBase.FlyToEarth
function RocketBase:FlyToEarth(flight_time, ...)
	if mod_TravelTimeEarthMars then
		flight_time = mod_TravelTimeEarthMars
	end
	return ChoOrig_RocketBase_FlyToEarth(self, flight_time, ...)
end

local ChoOrig_RocketBase_FlyToMars = RocketBase.FlyToMars
function RocketBase:FlyToMars(cargo, cost, flight_time, ...)
	if mod_TravelTimeMarsEarth then
		flight_time = mod_TravelTimeMarsEarth
	end
	return ChoOrig_RocketBase_FlyToMars(self, cargo, cost, flight_time, ...)
end

-- Some stuff checks one some other...
local SetConsts = ChoGGi_Funcs.Common.SetConsts

local function UpdateRockets()
	SetConsts("MaxColonistsPerRocket", mod_MaxColonistsPerRocket)
	SetConsts("TravelTimeEarthMars", mod_TravelTimeEarthMars)
	SetConsts("TravelTimeMarsEarth", mod_TravelTimeMarsEarth)
	SetConsts("RocketPrice", mod_RocketPrice)
	SetConsts("CargoCapacity", mod_CargoCapacity)
	SetConsts("FoodPerRocketPassenger", mod_FoodPerRocketPassenger)

	local objs =  UIColony.city_labels.labels.SupplyRocket or ""
	for i = 1, #objs do
		local obj = objs[i]
		obj.launch_fuel = mod_LaunchFuel
		obj.launch_fuel_expedition = mod_LaunchFuel
		obj.passenger_orbit_life = mod_PassengerOrbitLifetime
		obj.max_export_storage = mod_MaxExportStorage
	end
end
OnMsg.CityStart = UpdateRockets
OnMsg.LoadGame = UpdateRockets

-- fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	mod_LaunchFuel = options:GetProperty("LaunchFuel") * const.ResourceScale
	mod_MaxExportStorage = options:GetProperty("MaxExportStorage") * const.ResourceScale
	mod_PassengerOrbitLifetime = options:GetProperty("PassengerOrbitLifetime") * const.HourDuration
	mod_CargoCapacity = options:GetProperty("CargoCapacity") * const.ResourceScale
	mod_FoodPerRocketPassenger = options:GetProperty("FoodPerRocketPassenger") * const.ResourceScale
	mod_MaxColonistsPerRocket = options:GetProperty("MaxColonistsPerRocket")
	mod_TravelTimeEarthMars = options:GetProperty("TravelTimeEarthMars") * const.Scale.hours
	mod_TravelTimeMarsEarth = options:GetProperty("TravelTimeMarsEarth") * const.Scale.hours
	mod_RocketPrice = options:GetProperty("RocketPrice") * const.Scale.mil
	mod_DustStormFlight = options:GetProperty("DustStormFlight")

	-- make sure we're in-game
	if not UIColony then
		return
	end
	UpdateRockets()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
