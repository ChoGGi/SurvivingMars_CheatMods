-- See LICENSE for terms

local mod_LockMOXIEs

local function ToggleTechLock()
	-- add tech lock
	if mod_LockMOXIEs then
		-- build menu
		if not BuildingTechRequirements.MOXIE then
			BuildingTechRequirements.MOXIE = {{ tech = "MagneticFiltering", hide = false, }}
		end
		-- add an entry to unlock it with the tech
		local tech = TechDef.MagneticFiltering
		if not table.find(tech, "Building", "MOXIE") then
			tech[#tech+1] = PlaceObj('Effect_TechUnlockBuilding', {
				Building = "MOXIE",
			})
		end
	else
	-- remove lock
		BuildingTechRequirements.MOXIE = nil
		local tech = TechDef.MagneticFiltering
		local idx = table.find(tech, "Building", "MOXIE")
		if idx then
			table.remove(tech, idx)
		end
	end
end

OnMsg.CityStart = ToggleTechLock
OnMsg.LoadGame = ToggleTechLock

local oxygen_mod_options = {
	Child = 25,
	Youth = 25,
	Adult = 25,
	["Middle Aged"] = 25,
	Senior = 25,
}

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions

	mod_LockMOXIEs = options:GetProperty("LockMOXIEs")

	oxygen_mod_options.Child = options:GetProperty("OxygenUseChild")
	oxygen_mod_options.Youth = options:GetProperty("OxygenUseYouth")
	oxygen_mod_options.Adult = options:GetProperty("OxygenUseAdult")
	oxygen_mod_options["Middle Aged"] = options:GetProperty("OxygenUseMiddleAged")
	oxygen_mod_options.Senior = options:GetProperty("OxygenUseSenior")

	-- make sure we're in-game
	if not UICity then
		return
	end

	ToggleTechLock()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	-- I'm sure it wouldn't be that hard to only call this msg for the mod being applied, but...
	if id == CurrentModId then
		ModOptions()
	end
end

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

-- add modifier to each dome for colonist oxygen use
local orig_Dome_Init = Dome.Init
function Dome:Init(...)
  self.ChoGGi_OxygenManagement_oxygen_modifier = (ObjectModifier:new({
    target = self,
    prop = "air_consumption"
  }))
	return orig_Dome_Init(self, ...)
end

local function AirCount(dome, label)
	return #(dome.labels[label] or "") * oxygen_mod_options[label]
end

local orig_Dome_BuildingUpdate = Dome.BuildingUpdate
function Dome:BuildingUpdate(...)
	-- I have a mod to toggle opened domes (someone could make one for individual domes)
	if self:IsOpen() then
		-- no consumption for opened dome
		self.ChoGGi_OxygenManagement_oxygen_modifier:Change(0, 0)
	else
		local count = AirCount(self, "Child") + AirCount(self, "Senior")
			+ AirCount(self, "Middle Aged") + AirCount(self, "Adult") + AirCount(self, "Youth")

		self.ChoGGi_OxygenManagement_oxygen_modifier:Change(count, 0)
	end

	return orig_Dome_BuildingUpdate(self, ...)
end
