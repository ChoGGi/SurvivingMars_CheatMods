-- See LICENSE for terms

-- add the upgrades
function OnMsg.ClassesBuilt()
	local n = BuildingTemplates.Playground

	n.upgrade1_id = "Playground_max_visitors1"
	n.upgrade1_display_name = T(109035890389, "Capacity")
	n.upgrade1_description = T(0, "+<upgrade1_add_value_1> max_visitors, +1 <icon_Power> Consumption")
	n.upgrade1_icon = "UI/Icons/Upgrades/home_collective_01.tga"
	n.upgrade1_mod_prop_id_1 = "max_visitors"
	n.upgrade1_add_value_1 = 7
	n.upgrade1_mod_prop_id_2 = "electricity_consumption"
	n.upgrade1_add_value_2 = 1000
	n.upgrade1_upgrade_cost_Concrete = 5000
	n.upgrade1_upgrade_cost_Metals = 1000

	n.upgrade2_id = "Playground_max_visitors2"
	n.upgrade2_display_name = T(109035890389, "Capacity")
	n.upgrade2_description = T(0, "+<upgrade2_add_value_1> max_visitors, +1.5 <icon_Power> Consumption")
	n.upgrade2_icon = "UI/Icons/Upgrades/home_collective_01.tga"
	n.upgrade2_mod_prop_id_1 = "max_visitors"
	n.upgrade2_add_value_1 = 12
	n.upgrade2_mod_prop_id_2 = "electricity_consumption"
	n.upgrade2_add_value_2 = 1500
	n.upgrade2_upgrade_cost_Concrete = 10000
	n.upgrade2_upgrade_cost_Metals = 3000

	n.upgrade3_id = "Playground_max_visitors3"
	n.upgrade3_display_name = T(109035890389, "Capacity")
	n.upgrade3_description = T(0, "+<upgrade3_add_value_1> max_visitors, +2.5 <icon_Power> Consumption")
	n.upgrade3_icon = "UI/Icons/Upgrades/home_collective_01.tga"
	n.upgrade3_mod_prop_id_1 = "max_visitors"
	n.upgrade3_add_value_1 = 40
	n.upgrade3_mod_prop_id_2 = "electricity_consumption"
	n.upgrade3_add_value_2 = 2500
	n.upgrade3_upgrade_cost_Concrete = 15000
	n.upgrade3_upgrade_cost_Metals = 10000
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
