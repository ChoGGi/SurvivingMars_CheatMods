-- See LICENSE for terms

ChoGGi_ApartmentDoubleCapComfort = false

local capacity
local service_comfort

function OnMsg.ClassesBuilt()
	local a = BuildingTemplates.Apartments

	-- it's called more than once
	if ChoGGi_ApartmentDoubleCapComfort then
		return
	end

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

	ChoGGi_ApartmentDoubleCapComfort = true
end

-- this will update the settings for existing apartments
function OnMsg.LoadGame()
	-- so it only loops once per game
	if UICity.ChoGGi_ApartmentDoubleCapComfort then
		return
	end

	local objs = UICity.labels.Apartments or ""
	for i = 1, #objs do
		local obj = objs[i]
		obj.capacity = capacity
		obj.service_comfort = service_comfort
	end

	UICity.ChoGGi_ApartmentDoubleCapComfort = true
end
