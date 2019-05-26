-- See LICENSE for terms

-- add the upgrades
function OnMsg.ClassesBuilt()
	local p = BuildingTemplates.Playground

	p.upgrade1_id = "Playground_max_visitors1"
	p.upgrade1_display_name = T(109035890389, "Capacity")
	p.upgrade1_description = T(0, "+<upgrade1_add_value_1> max_visitors, +1 <icon_Power> Consumption")
	p.upgrade1_icon = "UI/Icons/Upgrades/home_collective_01.tga"
	p.upgrade1_mod_prop_id_1 = "max_visitors"
	p.upgrade1_add_value_1 = 7
	p.upgrade1_mod_prop_id_2 = "electricity_consumption"
	p.upgrade1_add_value_2 = 1000
	p.upgrade1_upgrade_cost_Concrete = 5000
	p.upgrade1_upgrade_cost_Metals = 1000

	p.upgrade2_id = "Playground_max_visitors2"
	p.upgrade2_display_name = T(109035890389, "Capacity")
	p.upgrade2_description = T(0, "+<upgrade2_add_value_1> max_visitors, +1.5 <icon_Power> Consumption")
	p.upgrade2_icon = "UI/Icons/Upgrades/home_collective_01.tga"
	p.upgrade2_mod_prop_id_1 = "max_visitors"
	p.upgrade2_add_value_1 = 12
	p.upgrade2_mod_prop_id_2 = "electricity_consumption"
	p.upgrade2_add_value_2 = 1500
	p.upgrade2_upgrade_cost_Concrete = 10000
	p.upgrade2_upgrade_cost_Metals = 3000

	p.upgrade3_id = "Playground_max_visitors3"
	p.upgrade3_display_name = T(109035890389, "Capacity")
	p.upgrade3_description = T(0, "+<upgrade3_add_value_1> max_visitors, +2.5 <icon_Power> Consumption")
	p.upgrade3_icon = "UI/Icons/Upgrades/home_collective_01.tga"
	p.upgrade3_mod_prop_id_1 = "max_visitors"
	p.upgrade3_add_value_1 = 40
	p.upgrade3_mod_prop_id_2 = "electricity_consumption"
	p.upgrade3_add_value_2 = 2500
	p.upgrade3_upgrade_cost_Concrete = 15000
	p.upgrade3_upgrade_cost_Metals = 10000
end

-- start with first upgrade unlocked
local function StartupCode()
	UICity.unlocked_upgrades.Playground_max_visitors1 = true
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

-- unlock the next two once the one before is built
function OnMsg.BuildingUpgraded(_, id)
	if id == "Playground_max_visitors1" then
		UICity.unlocked_upgrades.Playground_max_visitors2 = true
	elseif id == "Playground_max_visitors2" then
		UICity.unlocked_upgrades.Playground_max_visitors3 = true
	end
end
