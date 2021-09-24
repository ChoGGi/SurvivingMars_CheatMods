-- See LICENSE for terms

local mod_MrBumble

local function IsChildBld(obj)
	local s = obj:IsKindOf("School")
	local cb = s or obj:IsKindOf("Playground") or obj:IsKindOf("Nursery")
	return cb, s
end

local function UpdateBuildings(objs)
	for i = 1, #objs do
		local obj = objs[i]

		if mod_MrBumble then
			local cb, school = IsChildBld(obj)
			if cb then
				obj.usable_by_children = false
				if school then
					obj.force_lock_workplace = false
				end
			end
		else
			obj.usable_by_children = true
			if obj:IsKindOf("School") then
				obj.force_lock_workplace = true
			end
		end

	end
end

-- fired when settings are changed/init
local function ModOptions()
	mod_MrBumble = CurrentModOptions:GetProperty("MrBumble")

--~	local ct = ClassTemplates.Building
	local g_Classes = g_Classes

	local BuildingTemplates = BuildingTemplates
	for _, template in pairs(BuildingTemplates) do

		if mod_MrBumble then
			local cls = g_Classes[template.template_class]
			local cb, school = cls and IsChildBld(cls)
			if cb then
				template.usable_by_children = false
				if school then
					template.force_lock_workplace = false
				end
			end
		else
			template.usable_by_children = true
			local cls = g_Classes[template.template_class]
			if cls and cls:IsKindOf("School") then
				template.force_lock_workplace = true
			end
		end

	end

	if UICity then
		local labels = UICity.labels
		UpdateBuildings(labels.TrainingBuilding or "")
		UpdateBuildings(labels.Residence or "")

		-- give 'em the boot from playgrounds?
		local objs = labels.Service or ""
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
		objs = labels.Colonist or ""
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

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

-- update templates on load
OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions

-- needed for UpdateResidence
local ChoOrig_Residence_IsSuitable = Residence.IsSuitable
function Residence:IsSuitable(colonist, ...)
	if mod_MrBumble and colonist.age_trait == "Child" then
		return false
	end
	return ChoOrig_Residence_IsSuitable(self, colonist, ...)
end
