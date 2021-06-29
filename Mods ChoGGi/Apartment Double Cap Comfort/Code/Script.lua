-- See LICENSE for terms

local capacity
local service_comfort

-- update the templates for newly built buildings
function OnMsg.ClassesPostprocess()
	local a = BuildingTemplates.Apartments

	-- we need values for OnMsg.LoadGame
	capacity = a.capacity * 2
	service_comfort = a.service_comfort * 2

	-- update values
	a.capacity = capacity
	a.service_comfort = service_comfort
	-- and update again, cause...
	a = ClassTemplates.Building.Apartments
	a.capacity = capacity
	a.service_comfort = service_comfort

end

GlobalVar("g_ChoGGi_ApartmentDoubleCapComfort", false)

-- this will update the settings for existing apartments
function OnMsg.LoadGame()

	-- so the below only happens once per game (you can do it every load, but that'll take more time the more apartments).
	if not g_ChoGGi_ApartmentDoubleCapComfort then
		-- loop through all existing buildings and update them
		local objs = UICity.labels.Apartments or ""
		for i = 1, #objs do
			local obj = objs[i]
			obj.capacity = capacity
			obj.service_comfort = service_comfort
		end
	end
	-- update var kept in savefile
	g_ChoGGi_ApartmentDoubleCapComfort = true

end
