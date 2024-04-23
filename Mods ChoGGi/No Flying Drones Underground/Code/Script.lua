-- See LICENSE for terms

-- DLC installed
if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed! Abort!")
	return
end

if not g_AvailableDlc.gagarin then
	print(CurrentModDef.title, ": Space Race DLC not installed! Abort!")
	return
end

local mod_EnableMod

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local caller_city_id

local ChoOrig_GetDroneClass = GetDroneClass
function GetDroneClass(...)
	if not mod_EnableMod then
		return ChoOrig_GetDroneClass(...)
	end
	-- Should be changed by City:CreateDrone
	if not caller_city_id then
		caller_city_id = ActiveMapID
	end

  local environment = ActiveMaps[caller_city_id].Environment
	caller_city_id = nil

  if environment == "Underground" then
    return "Drone"
  end

	return ChoOrig_GetDroneClass(...)
end

-- this func calls GetDroneClass
local ChoOrig_City_CreateDrone = City.CreateDrone
function City:CreateDrone(...)
	caller_city_id = self.map_id
	return ChoOrig_City_CreateDrone(self, ...)
end
