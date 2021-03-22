-- See LICENSE for terms

local mod_LaunchFuel
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
local function SetConsts(id, value)
	Consts[id] = value
	g_Consts[id] = value
end

local function UpdateRockets()
	SetConsts("MaxColonistsPerRocket", mod_MaxColonistsPerRocket)
	SetConsts("TravelTimeEarthMars", mod_TravelTimeEarthMars)
	SetConsts("TravelTimeMarsEarth", mod_TravelTimeMarsEarth)
	SetConsts("RocketPrice", mod_RocketPrice)
	SetConsts("CargoCapacity", mod_CargoCapacity)
	SetConsts("FoodPerRocketPassenger", mod_FoodPerRocketPassenger)

	local objs =  UICity.labels.SupplyRocket or ""
	for i = 1, #objs do
		local obj = objs[i]
		obj.launch_fuel = mod_LaunchFuel
		obj.launch_fuel_expedition = mod_LaunchFuel
		obj.passenger_orbit_life = mod_PassengerOrbitLifetime
	end
end

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions
	mod_LaunchFuel = options:GetProperty("LaunchFuel") * const.ResourceScale
	mod_PassengerOrbitLifetime = options:GetProperty("PassengerOrbitLifetime") * const.HourDuration
	mod_CargoCapacity = options:GetProperty("CargoCapacity") * const.ResourceScale
	mod_FoodPerRocketPassenger = options:GetProperty("FoodPerRocketPassenger") * const.ResourceScale
	mod_MaxColonistsPerRocket = options:GetProperty("MaxColonistsPerRocket")
	mod_TravelTimeEarthMars = options:GetProperty("TravelTimeEarthMars") * const.Scale.hours
	mod_TravelTimeMarsEarth = options:GetProperty("TravelTimeMarsEarth") * const.Scale.hours
	mod_RocketPrice = options:GetProperty("RocketPrice") * const.Scale.mil

	-- make sure we're ingame
	if not UICity then
		return
	end
	UpdateRockets()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.CityStart = UpdateRockets
OnMsg.LoadGame = UpdateRockets
