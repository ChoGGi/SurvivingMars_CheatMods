-- See LICENSE for terms

local r = const.ResourceScale
local construction_cost_Concrete = 50 * r
local construction_cost_Polymers = 25 * r
local maintenance_resource_amount = 5 * r
local electricity_consumption = 10 * r
local capacity = 125

local function UpdateTemplate(a)
	a.construction_cost_Concrete = construction_cost_Concrete
	a.construction_cost_Polymers = construction_cost_Polymers
	a.maintenance_resource_amount = maintenance_resource_amount
	a.electricity_consumption = electricity_consumption
	a.capacity = capacity
end

function OnMsg.ClassesPostprocess()
	-- update values
	UpdateTemplate(BuildingTemplates.Apartments)
	-- and update again, cause...
	UpdateTemplate(ClassTemplates.Building.Apartments)
end

GlobalVar("g_ChoGGi_ApartmentDoubleCapComfort", false)

-- this will update the settings for existing apartments
function OnMsg.LoadGame()
	-- so it only loops once per save
	if g_ChoGGi_ApartmentDoubleCapComfort then
		return
	end

	local objs = UICity.labels.Apartments or ""
	for i = 1, #objs do
		local obj = objs[i]
		obj.construction_cost_Concrete = construction_cost_Concrete
		obj.construction_cost_Polymers = construction_cost_Polymers
		obj.maintenance_resource_amount = maintenance_resource_amount
		obj.electricity_consumption = electricity_consumption
		obj.capacity = capacity
	end

	g_ChoGGi_ApartmentDoubleCapComfort = true
end
