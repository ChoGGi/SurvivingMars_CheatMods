-- See LICENSE for terms

local orig_GetSpecialistEntity = GetSpecialistEntity
local ColonistClasses = ColonistClasses

function GetSpecialistEntity(specialist, gender, race, age_trait, traits, ...)
	if not (specialist ~= "none" and traits and traits.Android) then
		return orig_GetSpecialistEntity(specialist, gender, race, age_trait, traits, ...)
	end
	local spec = ColonistClasses[specialist or "none"]
	if not spec or spec == "" then
		spec = "Colonist"
	end

	-- there's just the gender icons
	local infopanel_icon = "UI/Icons/Colonists/IP/IP_Unit_" .. gender .. "_An_Adult_01.tga"
	local pin_icon = "UI/Icons/Colonists/Pin/Unit_" .. gender .. "_An_Adult_01.tga"
	-- but they did add entities
	local entity = "Unit_" .. spec .. "_" .. gender .. "_An_Adult_01"

	return entity, infopanel_icon, pin_icon
end

-- do we update on load?
function OnMsg.LoadGame()
	if UICity.ChoGGi_AndroidSpecUniforms or not IsTechResearched("ThePositronicBrain") then
		return
	end

	local objs = UICity.labels.Colonist or ""
	for i = 1, #objs do
		local obj = objs[i]
		if obj.specialist ~= "none" and obj.traits and obj.traits.Android and obj.entity:find("Colonist") then
			obj:ChooseEntity()
		end
	end
	UICity.ChoGGi_AndroidSpecUniforms = true
end
