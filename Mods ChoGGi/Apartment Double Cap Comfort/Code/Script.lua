-- See LICENSE for terms

local capacity
local service_comfort

function OnMsg.ClassesPostprocess()
	local a = BuildingTemplates.Apartments

	-- we need values for LoadGame
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

-- so it only updates once per game
GlobalVar("g_ChoGGi_ApartmentDoubleCapComfort", false)

-- this will update the settings for existing apartments
function OnMsg.LoadGame()
	if g_ChoGGi_ApartmentDoubleCapComfort then
		return
	end

	local objs = UICity.labels.Apartments or ""
	for i = 1, #objs do
		local obj = objs[i]
		obj.capacity = capacity
		obj.service_comfort = service_comfort
	end

	g_ChoGGi_ApartmentDoubleCapComfort = true
end
