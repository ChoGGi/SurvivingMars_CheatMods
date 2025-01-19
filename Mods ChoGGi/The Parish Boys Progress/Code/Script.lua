-- See LICENSE for terms

local mod_EnableMod
local mod_MrBumble
local mod_MrBumbleNursery

local function IsChildBld(obj)
	local school = obj:IsKindOf("School")
	local child_building = school or obj:IsKindOf("Playground")
	if mod_MrBumbleNursery then
		child_building = school or obj:IsKindOf("Playground") or obj:IsKindOf("Nursery")
	end

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

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_MrBumble = CurrentModOptions:GetProperty("MrBumble")
	mod_MrBumbleNursery = CurrentModOptions:GetProperty("MrBumbleNursery")

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
		if mod_MrBumbleNursery then
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
		else
			for i = 1, #objs do
				local obj = objs[i]
				if obj.age_trait == "Child" then
					obj:SetWorkplace(false)
					obj:UpdateWorkplace()
				end
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
	if not mod_EnableMod then
		return ChoOrig_Residence_IsSuitable(self, colonist, ...)
	end

	if mod_MrBumble and colonist.age_trait == "Child" and IsChildBld(self) then
		return false
	end
	return ChoOrig_Residence_IsSuitable(self, colonist, ...)
end

-- I don't like copying and pasting, but
-- lua rev 1011166
local function HasIncompatibleTraits(workplace, unit_traits)
	for _, trait in ipairs(workplace.incompatible_traits) do
		if unit_traits[trait] then
			return true
		end
	end
end

local ChoOrig_Workplace_ColonistCanInteract = Workplace.ColonistCanInteract
function Workplace:ColonistCanInteract(col, ...)
	if not mod_EnableMod then
		return ChoOrig_Workplace_ColonistCanInteract(self, col, ...)
	end

	local traits = col.traits
--~ 	if traits.Child or (traits.Senior and not g_SeniorsCanWork) then
	if traits.Senior and not g_SeniorsCanWork then
		return false, T(4310, "<red>Seniors and children can't be assigned to work</red>")
	end
	if self.specialist_enforce_mode and (self.specialist or "none") ~= (col.specialist or "none") then
		return false, T(8769, "Required specialization mismatch")
	end
	if col.workplace == self then
		return false, T(4311, "Current Workplace")
	end
	if not col:CanReachBuilding(self) then
		return false, T(4308, "<red>Out of reach</red>")
	end
	if not self:HasOpenWorkSlots() then
		return false, T(4312, "<red>Current work shift is closed</red>")
	end
	if HasIncompatibleTraits(self, traits) then
		return false, T(12595, "<red>Can't work here</red>")
	end
	return true, T{4313, "<UnitMoveControl('ButtonA', interaction_mode)>: Set Workplace", col}
end

-- All the below for a local func instead of devs having it as a class func
-- lua rev 1011166
local function _IsWorkStatusOk(traits, status_effects)
	return (not traits.Senior or g_SeniorsCanWork)
--~ 		and not traits.Child
		and not traits.Tourist
		and not status_effects.StatusEffect_Earthsick
end

-- can be employed; colonists for which this returns false should quit their jobs
local ChoOrig_Colonist_CanWork = Colonist.CanWork
function Colonist:CanWork(...)
	if not mod_EnableMod or self.age_trait ~= "Child" then
		return ChoOrig_Colonist_CanWork(self, ...)
	end

	local traits = self.traits
	local status_effects = self.status_effects
	return
		_IsWorkStatusOk(traits, status_effects)
		and (traits.Fit or not (self.stat_health < g_Consts.LowStatLevel))
		and not status_effects.StatusEffect_StressedOut
		and self:CanChangeCommand()
end

local ChoOrig_Colonist_IsTemporaryIll = Colonist.IsTemporaryIll
function Colonist:IsTemporaryIll(...)
	if not mod_EnableMod or self.age_trait ~= "Child" then
		return ChoOrig_Colonist_CanWork(self, ...)
	end

	local traits = self.traits
	local status_effects = self.status_effects
	return
		_IsWorkStatusOk(traits, status_effects)
		and (not traits.Fit and (self.stat_health < g_Consts.LowStatLevel))
		and status_effects.StatusEffect_StressedOut
		and self:CanChangeCommand()
end
