-- See LICENSE for terms

local ToggleWorking = ChoGGi.ComFuncs.ToggleWorking

local mod_AutoPerformance

local mod_options = {}
function OnMsg.ClassesPostprocess()
	local g_Classes = g_Classes
	local BuildingTemplates = BuildingTemplates
	for id, item in pairs(BuildingTemplates) do
		local cls_obj = g_Classes[item.template_class]
		if cls_obj and IsKindOf(cls_obj, "Factory") then
			mod_options[id] = false
		end
	end
end

-- Custom buildings
mod_options.DroneFactory = false
if g_AvailableDlc.picard then
	mod_options.ReconCenter = false
end

local function UpdateBuildings()

	-- make newly built buildings not need workers
	local bt = BuildingTemplates
	local ct = ClassTemplates.Building

	for id, item in pairs(bt) do
		local bool = mod_options[id]
		if bool then
			item.max_workers = 0
			item.automation = 1
			item.auto_performance = mod_AutoPerformance
			item.dome_required = false
			local cls_temp = ct[id]
			cls_temp.max_workers = 0
			cls_temp.automation = 1
			cls_temp.auto_performance = mod_AutoPerformance
			cls_temp.dome_required = false
		-- don't want to "reset" non-factories
		elseif bool == false then
			item.max_workers = nil
			item.automation = nil
			item.auto_performance = nil
			local cls_temp = ct[id]
			cls_temp.max_workers = nil
			cls_temp.automation = nil
			cls_temp.auto_performance = nil
		end
	end

	local UIColony = UIColony
	-- update existing buildings
	local objs = {}
	for id in pairs(mod_options) do
		table.iappend(objs, UIColony:GetCityLabels(id))
	end

	for i = 1, #objs do
		local obj = objs[i]

		if mod_options[obj.template_name] then
			obj.max_workers = 0
			obj.automation = 1
			obj.auto_performance = mod_AutoPerformance
		else
			obj.max_workers = nil
			obj.automation = nil
			obj.auto_performance = nil
		end

		ToggleWorking(obj)
	end
end
OnMsg.CityStart = UpdateBuildings
OnMsg.LoadGame = UpdateBuildings

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	for id in pairs(mod_options) do
		mod_options[id] = options:GetProperty(id)
	end

	mod_AutoPerformance = options:GetProperty("AutoPerformance")

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	UpdateBuildings()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- Place outside of domes
local ChoOrig_Workplace_HasNearByWorkers = Workplace.HasNearByWorkers
function Workplace:HasNearByWorkers(...)
	if mod_options[self.template_name] then
		return true
	end
	return ChoOrig_Workplace_HasNearByWorkers(self, ...)
end
