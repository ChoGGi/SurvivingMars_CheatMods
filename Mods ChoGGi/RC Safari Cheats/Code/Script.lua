-- See LICENSE for terms

local mod_RCSafariMaxWaypoints
local mod_SightRange
local mod_MaxPassengers
local mod_SatisfactionChange
local mod_HealthChange
local mod_SanityChange
local mod_ServiceComfort
local mod_ComfortIncrease

-- some stuff checks one some other...
local function SetConsts(id, value)
	Consts[id] = value
	g_Consts[id] = value
end

local function UpdateRovers()
	SetConsts("RCSafariMaxWaypoints", mod_RCSafariMaxWaypoints)

	local objs =  UICity.labels.RCSafari or ""
	for i = 1, #objs do
		local obj = objs[i]
		obj.sight_range = mod_SightRange
		-- for when they update it?
--~ 		obj.max_passengers = mod_MaxPassengers
		obj.max_visitors = mod_MaxPassengers
		obj.satisfaction_change = mod_SatisfactionChange
		obj.health_change = mod_HealthChange
		obj.sanity_change = mod_SanityChange
		obj.service_comfort = mod_ServiceComfort
		obj.comfort_increase = mod_ComfortIncrease
	end
end

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions
	MaxRouteLength = options:GetProperty("MaxSafariLength")

	mod_RCSafariMaxWaypoints = options:GetProperty("RCSafariMaxWaypoints")
	mod_SightRange = options:GetProperty("SightRange")
	mod_MaxPassengers = options:GetProperty("MaxPassengers")
	mod_SatisfactionChange = options:GetProperty("SatisfactionChange") * const.ResourceScale
	mod_HealthChange = options:GetProperty("HealthChange") * const.ResourceScale
	mod_SanityChange = options:GetProperty("SanityChange") * const.ResourceScale
	mod_ServiceComfort = options:GetProperty("ServiceComfort") * const.ResourceScale
	mod_ComfortIncrease = options:GetProperty("ComfortIncrease") * const.ResourceScale

	-- make sure we're ingame
	if not UICity then
		return
	end
	UpdateRovers()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.CityStart = UpdateRovers
OnMsg.LoadGame = UpdateRovers

local orig_CreateWaypointLabel = CreateWaypointLabel
function CreateWaypointLabel(index, ...)

	-- cycle the models...
	if mod_RCSafariMaxWaypoints > 10 then
		index = index % 10
		if index == 0 then
			index = 10
		end
	end

	return orig_CreateWaypointLabel(index, ...)
end
