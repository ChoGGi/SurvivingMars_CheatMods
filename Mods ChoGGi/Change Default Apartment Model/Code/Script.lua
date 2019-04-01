-- See LICENSE for terms

if not IsValidEntity("ApartmentsCP3") then
	return
end

local function ChangeEntity(template)
	template.entity = "ApartmentsCP3"
	template.entity5 = "HiveHabitat"
	template.entitydlc5 = ""
end

local function StartupCode()
	ChangeEntity(BuildingTemplates.Apartments)
	ChangeEntity(ClassTemplates.Building.Apartments)
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
