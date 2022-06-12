-- See LICENSE for terms

local ColonistClasses = ColonistClasses
local function GetSpec(specialist)
	local spec = ColonistClasses[specialist or "none"]
	if not spec or spec == "" then
		return "Colonist"
	end
	return spec
end

local ChoOrig_GetSpecialistEntity = GetSpecialistEntity
function GetSpecialistEntity(specialist, gender, race, age_trait, traits, ...)
	if not (specialist ~= "none" and traits and traits.Android) then
		return ChoOrig_GetSpecialistEntity(specialist, gender, race, age_trait, traits, ...)
	end

	local spec = GetSpec(specialist)
	-- "gender" icons
	local infopanel_icon = "UI/Icons/Colonists/IP/IP_Unit_" .. gender .. "_An_Adult_01.tga"
	local pin_icon = "UI/Icons/Colonists/Pin/Unit_" .. gender .. "_An_Adult_01.tga"
	-- and models
	local entity = "Unit_" .. spec .. "_" .. gender .. "_An_Adult_01"

	return entity, infopanel_icon, pin_icon
end


local ChoOrig_GetSpecializationIcons = Colonist.GetSpecializationIcons
function Colonist:GetSpecializationIcons(...)
	if not (self.specialist ~= "none" and self.traits and self.traits.Android) then
		return ChoOrig_GetSpecializationIcons(self, ...)
	end

	local spec = GetSpec(self.specialist)
	-- pinned and workplace icons
	return "UI/Icons/Colonists/IP/IP_" .. spec .. "_" .. self.entity_gender .. ".tga",
		"UI/Icons/Colonists/Pin/" .. spec .. "_" .. self.entity_gender .. ".tga"
end

GlobalVar("ChoGGi_AndroidSpecUniforms", false)

-- do we update on load?
function OnMsg.LoadGame()
	if ChoGGi_AndroidSpecUniforms then
		return
	end

	local objs = UIColony:GetCityLabels("Colonist")
	for i = 1, #objs do
		local obj = objs[i]
		if obj.specialist ~= "none" and obj.traits and obj.traits.Android
			and (obj.entity:find("Colonist") or not obj.pin_specialization_icon
				or obj.ip_specialization_icon == ""
			)
		then
			obj:ChooseEntity()
		end
	end

	ChoGGi_AndroidSpecUniforms = true
end
