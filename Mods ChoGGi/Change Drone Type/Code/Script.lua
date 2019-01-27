-- See LICENSE for terms

ChangeDroneType = {
	Aerodynamics = false,
}

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true

	-- version to version check with
	local min_version = 51
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	-- if we can't find mod or mod is less then min_version (we skip steam since it updates automatically)
	if not idx or idx and not Platform.steam and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Change Drone Type requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- function called when a drone is created
function City:CreateDrone()
  local classdef = g_Classes[UICity.drone_class] or Drone
  return classdef:new{city = self}
end

-- devs made PickEntity always default to whatever has been spawned already, which we don't want
local IsValidEntity = IsValidEntity
local function PickEntity(self)
	local new_entity = g_Classes[self.class].entity
	if new_entity ~= self:GetEntity() and IsValidEntity(new_entity) then
		self:ChangeEntity(new_entity)
	end
end

Drone.PickEntity = PickEntity
FlyingDrone.PickEntity = PickEntity

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

-- add button to selection panels
function OnMsg.ClassesBuilt()
	local S = ChoGGi.Strings
	local type_str = string.format("%s: %s",S[302535920000266--[[Spawn--]]],"%s")
	local name_table = {
		FlyingDrone = S[10278--[[Wasp Drone--]]],
		Drone = S[1681--[[Drone--]]],
	}

	local template_table = {
		RolloverTitle = [[Change Spawn Type]],
		RolloverText = [[Spawn wasp drones or regular drones.]],
		Title = [[Drone Type]],
		Icon = "UI/Icons/Sections/drone.tga",

		__condition = function()
			if ChangeDroneType.Aerodynamics then
				return UICity:IsTechResearched("MartianAerodynamics")
			else
				return true
			end
		end,

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
