-- See LICENSE for terms

local mod_MrBumble

local function IsChildBld(obj)
	local school = obj:IsKindOf("School")
	local child_building = school or obj:IsKindOf("Playground") or obj:IsKindOf("Nursery")
	return child_building, school
end

local function UpdateBuildings(objs)
	for i = 1, #objs do
		local obj = objs[i]
		local child_building, school = IsChildBld(obj)

		if mod_MrBumble and child_building then
			obj.usable_by_children = false
			if school then
				obj.force_lock_workplace = false
			end
		end

		if not child_building then
			obj.usable_by_children = true
			if obj:IsKindOf("School") then
				obj.force_lock_workplace = true
			end
		end

	end
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_MrBumble = CurrentModOptions:GetProperty("MrBumble")

	local g_Classes = g_Classes

	local BuildingTemplates = BuildingTemplates
	for _, template in pairs(BuildingTemplates) do
		local cls = g_Classes[template.template_class]
		local child_building, school = cls and IsChildBld(cls)

		if mod_MrBumble and child_building then
			template.usable_by_children = false
			if school then
				template.force_lock_workplace = false
			end
		end

		if not child_building then
			template.usable_by_children = true
			if cls and cls:IsKindOf("School") then
				template.force_lock_workplace = true
			end
		end

	end

	if UIColony then
		UpdateBuildings(UIColony:GetCityLabels("TrainingBuilding"))
		UpdateBuildings(UIColony:GetCityLabels("Residence"))

		-- give 'em the boot from playgrounds
		local objs = UIColony:GetCityLabels("Service")
		for i = 1, #objs do
			local obj = objs[i]
			if obj:IsKindOf("Playground") then
				if mod_MrBumble then
					obj:KickUnitsFromHolder()
					obj.usable_by_children = false
				else
					obj.usable_by_children = true
				end
			end
		end

		-- update res/workplaces
		objs = UIColony:GetCityLabels("Colonist")
		for i = 1, #objs do
			local obj = objs[i]
			if obj.age_trait == "Child" then
				-- needed to bypass Nursery
				obj:SetResidence(false)
				obj:UpdateResidence()
				obj:SetWorkplace(false)
				obj:UpdateWorkplace()
			end
		end
	end
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- update templates on load
OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions

-- needed for UpdateResidence
local ChoOrig_Residence_IsSuitable = Residence.IsSuitable
function Residence:IsSuitable(colonist, ...)
	if mod_MrBumble and colonist.age_trait == "Child" and IsChildBld(self) then
		return false
	end
	return ChoOrig_Residence_IsSuitable(self, colonist, ...)
end
