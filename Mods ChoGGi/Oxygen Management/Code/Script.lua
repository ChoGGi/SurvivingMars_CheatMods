-- See LICENSE for terms

ChoGGi.ComFuncs.AddParentToClass(ElectronicsFactory, "LifeSupportConsumer")
ChoGGi.ComFuncs.AddParentToClass(MachinePartsFactory, "LifeSupportConsumer")

function OnMsg.ClassesPostprocess()
	local bt = BuildingTemplates
	local ct = ClassTemplates.Building

-- reduce standard MOXIE production to 2 oxygen, increase upkeep to 10 power
-- You could consider making MOXIES prefab/tech dependent like the vaporators, say by switching the MOXIE upgrade tech with a MOXIE building tech. And/or add a polymer cost?
	local electricity_consumption = 10000
	local air_production = 2000
	local construction_cost_Polymers = 2000

	local moxie = bt.MOXIE
	-- update values
	moxie.electricity_consumption = electricity_consumption
	moxie.air_production = air_production
	moxie.construction_cost_Polymers = construction_cost_Polymers
	-- and update again, cause...
	moxie = ct.Apartments
	moxie.electricity_consumption = electricity_consumption
	moxie.air_production = air_production
	moxie.construction_cost_Polymers = construction_cost_Polymers

-- Increase algea oxygen production to 2, kelp to 1 (this could be the hydroponic farm niche we need)
	local crops = CropPresets
	crops.Algae.OxygenProduction = 2000
	crops.Kelp.OxygenProduction = 1000

-- factories cost additional 2 oxygen (even if they do not run on coal, we can assume something in there is not good for the air, at least to the same degree as a fungus)
	for id, template in pairs(bt) do
		local cls_obj = g_Classes[template.template_class]
		if cls_obj and cls_obj:IsKindOf("Factory") then
			if id == "ElectronicsFactory_Small" or id == "MachinePartsFactory_Small" then
				template.air_consumption = 1000
				ct[id].air_consumption = 1000
				-- LifeSupportConsumer defaults to 10 water
				template.water_consumption = 0
				ct[id].water_consumption = 0
			else
				template.air_consumption = 2000
				ct[id].air_consumption = 2000
				template.water_consumption = 0
				ct[id].water_consumption = 0
			end
		end
	end

end

--~ local function ToggleTech()
--~ 	-- build menu
--~ 	if not BuildingTechRequirements.MOXIE then
--~ 		BuildingTechRequirements.MOXIE = {{ tech = "MagneticFiltering", hide = false, }}
--~ 	end
--~ 	-- add an entry to unlock it with the tech
--~ 	local tech = TechDef.MagneticFiltering
--~ 	if not table.find(tech, "Building", "MOXIE") then
--~ 		tech[#tech+1] = PlaceObj('Effect_TechUnlockBuilding', {
--~ 			Building = "MOXIE",
--~ 		})
--~ 	end
--~ end

--~ OnMsg.CityStart = ToggleTech
--~ OnMsg.LoadGame = ToggleTech

-- you could consider additional oxygen cost per colonist, though I assume there is a reason water and O2 are currently calculated per dome instead of per inhabitant.

-- add modifier to each dome for colonist oxygen use
local orig_Dome_Init = Dome.Init
function Dome:Init(...)
  self.ChoGGi_OxygenManagement_oxygen_modifier = (ObjectModifier:new({
    target = self,
    prop = "air_consumption"
  }))
	return orig_Dome_Init(self, ...)
end

local air_usage = {
	Child = 35,
	Senior = 70,
	["Middle Aged"] = 85,
	Adult = 90,
	Youth = 100,
}
local function AirCount(dome, label)
	return #(dome.labels[label] or "") * air_usage[label]
end

local orig_Dome_BuildingUpdate = Dome.BuildingUpdate
function Dome:BuildingUpdate(...)
	local count = AirCount(self, "Child") + AirCount(self, "Senior")
		+ AirCount(self, "Middle Aged") + AirCount(self, "Adult") + AirCount(self, "Youth")
  self.ChoGGi_OxygenManagement_oxygen_modifier:Change(count, 0)

	return orig_Dome_BuildingUpdate(self, ...)
end
