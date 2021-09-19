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

-- override for custom_travel_time_mars/custom_travel_time_earth
local orig_RocketBase_FlyToEarth = RocketBase.FlyToEarth
function RocketBase:FlyToEarth(flight_time, ...)
	if mod_TravelTimeEarthMars then
		flight_time = mod_TravelTimeEarthMars
	end
	return orig_RocketBase_FlyToEarth(self, flight_time, ...)
end

local orig_RocketBase_FlyToMars = RocketBase.FlyToMars
function RocketBase:FlyToMars(cargo, cost, flight_time, ...)
	if mod_TravelTimeMarsEarth then
		flight_time = mod_TravelTimeMarsEarth
	end
	return orig_RocketBase_FlyToMars(self, cargo, cost, flight_time, ...)
end

-- some stuff checks one some other...
local SetConstsG = ChoGGi.ComFuncs.SetConstsG

local function UpdateRockets()
	SetConstsG("MaxColonistsPerRocket", mod_MaxColonistsPerRocket)
	SetConstsG("TravelTimeEarthMars", mod_TravelTimeEarthMars)
	SetConstsG("TravelTimeMarsEarth", mod_TravelTimeMarsEarth)
	SetConstsG("RocketPrice", mod_RocketPrice)
	SetConstsG("CargoCapacity", mod_CargoCapacity)
	SetConstsG("FoodPerRocketPassenger", mod_FoodPerRocketPassenger)

	local objs =  UICity.labels.SupplyRocket or ""
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

	-- make sure we're in-game
	if not UICity then
		return
	end
	UpdateRockets()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions
