-- See LICENSE for terms

--[[
	Locally stored values
	Anything else is global which means longer lookup (local as in the file, not the mod)
]]
local capacity, service_comfort

-- helper func used below (I prefer not duplicating code)
local function UpdateTemplate(a)
	a.capacity = capacity
	a.service_comfort = service_comfort
end

-- Update the templates (used for newly built buildings)
function OnMsg.ClassesPostprocess()
	local a = BuildingTemplates.Apartments

	-- Store doubled values for later use
	capacity = a.capacity * 2
	service_comfort = a.service_comfort * 2

	-- Update values
	UpdateTemplate(a)
	-- and update again, cause... (some stuff uses BuildingTemplates, other uses ClassTemplates)
	UpdateTemplate(ClassTemplates.Building.Apartments)

end

GlobalVar("g_ChoGGi_ApartmentDoubleCapComfort", false)

-- Update the settings for existing apartment buildings
function OnMsg.LoadGame()

	--[[
		The "if" is so the below only happens once per game
		you can do it every load, but that'll take more time the more apartments.
	]]
	if not g_ChoGGi_ApartmentDoubleCapComfort then
		-- loop through all existing buildings and update them
		local objs = UIColony:GetCityLabels("Apartments")
		for i = 1, #objs do
			local obj = objs[i]
			obj.capacity = capacity
			obj.service_comfort = service_comfort
		end
	end
	-- update var kept in save file
	g_ChoGGi_ApartmentDoubleCapComfort = true

end
