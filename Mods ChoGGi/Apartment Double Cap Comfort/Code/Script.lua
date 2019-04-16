-- See LICENSE for terms

local capacity
local comfort

function OnMsg.ClassesBuilt()
	local a = BuildingTemplates.Apartments
	capacity = a.capacity * 2
	comfort = a.service_comfort * 2
end

-- change settings on newly spawned apartments
function OnMsg.BuildingInit(obj)
	if not obj:IsKindOf("Apartments") then
		return
	end
	obj.capacity = capacity
	obj.service_comfort = comfort
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
		obj.service_comfort = comfort
	end

	UICity.ChoGGi_ApartmentDoubleCapComfort = true
end
