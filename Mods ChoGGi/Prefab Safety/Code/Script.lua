-- See LICENSE for terms

local table = table

-- add marker to any prefab building
local ChoOrig_ConstructionSite_Complete = ConstructionSite.Complete
function ConstructionSite:Complete(...)
	local ret = {ChoOrig_ConstructionSite_Complete(self, ...)}

	if self.prefab then
		ret[1].ChoGGi_PrefabSafety = true
	end

	return table.unpack(ret)
end

-- need to get the proper class name for rover buildings
local rover_building_lookup = {}
function OnMsg.ClassesBuilt()
	ClassDescendants("BaseRoverBuilding", function(class, building)
		rover_building_lookup[building.rover_class] = class
	end)
end

-- we don't want it adding a prefab when the site is removed
local skip = {"ConstructionSite", "BaseRoverBuilding"}

local function Refund(self)
	if self.ChoGGi_PrefabSafety and not self:IsKindOfClasses(skip) then

		local cls = rover_building_lookup[self.class]
		if not cls then
			cls = self.template_name or self.class
		end

		local prefabs = UICity.available_prefabs
		local amount = prefabs[cls] or 0
		prefabs[cls] = amount + 1
	end
end

-- add back prefab only after BaseBuilding is completely removed
local ChoOrig_BaseBuilding_delete = BaseBuilding.delete or Object.delete
function BaseBuilding:delete(...)
	Refund(self)
	return ChoOrig_BaseBuilding_delete(self, ...)
end

-- of course rovers have to be different
local ChoOrig_BaseRoverBuilding_GameInit = BaseRoverBuilding.GameInit
function BaseRoverBuilding:GameInit(...)
	if not self.ChoGGi_PrefabSafety then
		return ChoOrig_BaseRoverBuilding_GameInit(self, ...)
	end

	CreateGameTimeThread(function()
		if self.rover_class then
			local rover = PlaceObjectIn(self.rover_class, self:GetMapID())
			local spot = self:GetSpotBeginIndex("Rover")
			local pos, angle = self:GetSpotLoc(spot)
			rover:SetPos(pos)
			rover:SetAngle(angle)

			rover.ChoGGi_PrefabSafety = true

			self:delete()
		end
	end)
end

-- decom tech
local function StartupCode()
	if not IsTechResearched("DecommissionProtocol") then
		GrantTech("DecommissionProtocol")
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
