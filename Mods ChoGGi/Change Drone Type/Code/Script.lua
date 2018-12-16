-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true

	-- version to version check with
	local min_version = 48
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	-- if we can't find mod or mod is less then min_version (we skip steam since it updates automatically)
	if not idx or idx and not Platform.steam and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Hub Drone Type requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

--~ -- replace drone spawn commands
--~ local function SpawnDrone(self)
--~ 	local drone_class = self.ChoGGi_drone_class or "Drone"
--~ 	local classdef = drone_class and g_Classes[drone_class] or Drone
--~ 	local drone = classdef:new{city = self.city or UICity}
--~ 	return drone
--~ end

--~ local orig_DroneHub_SpawnDrone = DroneHub.SpawnDrone
--~ function DroneHub:SpawnDrone(...)
--~ 	if self.ChoGGi_drone_class then
--~ 		if #self.drones >= g_Consts.CommandCenterMaxDrones then
--~ 			return false
--~ 		end

--~ 		local drone = SpawnDrone(self)

--~ 		drone:SetHolder(self)
--~ 		drone:SetCommandCenter(self)
--~ 	else
--~ 		return orig_DroneHub_SpawnDrone(self, ...)
--~ 	end

--~ 	return true
--~ end

--~ local orig_RCRover_SpawnDrone = RCRover.SpawnDrone
--~ function RCRover:SpawnDrone(...)
--~ 	if self.ChoGGi_drone_class then
--~ 		if #self.drones >= self:GetMaxDrones() then
--~ 			return
--~ 		end

--~ 		local drone = SpawnDrone(self)

--~ 		drone.init_with_command = false
--~ 		drone:SetCommandCenter(self)
--~ 		self:DroneEnter(drone, true)
--~ 		if self.siege_state_name == "Siege" then
--~ 			self:ExitDronesOutOfCommand()
--~ 		end
--~ 	else
--~ 		return orig_RCRover_SpawnDrone(self, ...)
--~ 	end

--~ 	return true
--~ end

function City:CreateDrone()
  local drone_class = UICity.drone_class or "Drone"
  local classdef = drone_class and g_Classes[drone_class] or Drone
  return classdef:new({city = self})
end

-- for some reason they made PickEntity always default to whatever has been spawned already, which we don't want
local function PickEntity(self)
	local new_entity = g_Classes[self.class].entity
	if new_entity ~= self:GetEntity() then
		assert(IsValidEntity(new_entity))
		self:ChangeEntity(new_entity)
	end
end

function Drone:PickEntity()
	PickEntity(self)
end

function FlyingDrone:PickEntity()
	PickEntity(self)
end

-- drones have a func to set skins of all drones in same cc
function Drone:ChangeSkin(skin, palette)
  self:OnSkinChanged(skin, palette)
  local cc = self.command_center
	local drones = cc and cc.drones or ""
	for i = 1, #drones do
		local drone = drones[i]
    if drone ~= self and not drone:IsKindOf("FlyingDrone") then
      drone:OnSkinChanged(skin, palette)
    end
  end
end

-- add button to selection panel

function OnMsg.ClassesBuilt()
	local S = ChoGGi.Strings
	local type_str = string.format("%s: %s",S[302535920000266--[[Spawn--]]],"%s")
	local name_table = {
		FlyingDrone = S[10278--[[Wasp Drone--]]],
		Drone = S[1681--[[Drone--]]],
	}

	local template_table = {
		RolloverTitle = [[Change Spawn Type]],
		RolloverText = [[Spawn Wasp drones or regular drones.]],
		Title = [[Drone Type]],
		Icon = "UI/Icons/Sections/drone.tga",

		OnContextUpdate = function(self, context)
			local city = context.city or UICity
			self:SetTitle(type_str:format(
				name_table[city.drone_class or "Drone"]
			))
		end,

		func = function(self, context)
			---
			local city = context.city or UICity
			if city.drone_class == "Drone" then
				city.drone_class = "FlyingDrone"
			else
				city.drone_class = "Drone"
			end
			self:SetTitle(type_str:format(name_table[city.drone_class]))
			---
		end,
	}

	template_table.__context_of_kind = "RCRover"
	ChoGGi.ComFuncs.AddXTemplate("ChangeDroneType","ipRover",template_table)

	template_table.__context_of_kind = "DroneHub"
	ChoGGi.ComFuncs.AddXTemplate("ChangeDroneType","ipBuilding",template_table)

end

-- set default drone type
local GetMissionSponsor = GetMissionSponsor
local function StartupCode()
	local city = UICity
	city.drone_class = city.drone_class or GetMissionSponsor().drone_class or "Drone"
end

function OnMsg.CityStart()
	StartupCode()
end

function OnMsg.LoadGame()
	StartupCode()
end
