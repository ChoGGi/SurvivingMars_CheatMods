-- See LICENSE for terms

if not IsValidEntity("ApartmentsCP3") then
	return
end

-- swap around default and "step" entity
local function SwapEntity(template)
	template.entity = "ApartmentsCP3"
	template.entity5 = "HiveHabitat"
	template.entitydlc5 = ""

	template.entity = "ApartmentsCP3"
	template.palette_color1 ="inside_base"
	template.palette_color2 ="inside_wood"
	template.palette_color3 ="none"

	template.entity5 = "HiveHabitat"
	template.palette5_color1 ="inside_accent_1"
	template.palette5_color2 ="inside_base"
	template.palette5_color3 ="inside_accent_housing"
end

function OnMsg.ClassesPostprocess()
	SwapEntity(BuildingTemplates.Apartments)
	SwapEntity(ClassTemplates.Building.Apartments)
end
