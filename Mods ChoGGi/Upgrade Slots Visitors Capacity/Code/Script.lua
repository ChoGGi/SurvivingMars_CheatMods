-- See LICENSE for terms

local function AddUpgrades(obj, id, prop, value)
	if value > 1000 then
		value = value / const.ResourceScale
	end

	local elec2 = 1500
	-- I'm sure there's a way to make this display as 1.5, but I'm too lazy to find out
	local elec2_description = "+<upgrade2_add_value_1> Capacity, +1.5 <icon_Power> Consumption"

	-- don't override built-in upgrades
	if obj.upgrade1_id == "" then
		obj.upgrade1_id = id .. "_Capacity1"
		obj.upgrade1_display_name = T(109035890389, "Capacity")
		obj.upgrade1_description = T(0, "+<upgrade1_add_value_1> Capacity, +1 <icon_Power> Consumption")
		obj.upgrade1_icon = "UI/Icons/Upgrades/home_collective_01.tga"
		obj.upgrade1_mod_prop_id_1 = prop
		obj.upgrade1_add_value_1 = value
		obj.upgrade1_mod_prop_id_2 = "electricity_consumption"
		obj.upgrade1_add_value_2 = 1000
		obj.upgrade1_upgrade_cost_Concrete = 5000
		obj.upgrade1_upgrade_cost_Metals = 1000
	else
		if obj.upgrade1_id ~= id .. "_Capacity1" then
			-- add more cap if upgrade1 is taken (floatfloor for 15 instead of 15.0)
			value = floatfloor(value * 1.5)
			elec2 = 2500
			elec2_description = "+<upgrade2_add_value_1> Capacity, +2.5 <icon_Power> Consumption"
		end
	end

	if obj.upgrade2_id == "" then
		obj.upgrade2_id = id .. "_Capacity2"
		obj.upgrade2_display_name = T(109035890389, "Capacity")
		obj.upgrade2_description = T(0, elec2_description)
		obj.upgrade2_icon = "UI/Icons/Upgrades/home_collective_01.tga"
		obj.upgrade2_mod_prop_id_1 = prop
		obj.upgrade2_add_value_1 = value
		obj.upgrade2_mod_prop_id_2 = "electricity_consumption"
		obj.upgrade2_add_value_2 = elec2
		obj.upgrade2_upgrade_cost_Concrete = 10000
		obj.upgrade2_upgrade_cost_Metals = 3000
	end

	if obj.upgrade3_id == "" then
		obj.upgrade3_id = id .. "_Capacity3"
		obj.upgrade3_display_name = T(109035890389, "Capacity")
		obj.upgrade3_description = T(0, "+<upgrade3_add_value_1> Capacity, +2.5 <icon_Power> Consumption")
		obj.upgrade3_icon = "UI/Icons/Upgrades/home_collective_01.tga"
		obj.upgrade3_mod_prop_id_1 = prop
		obj.upgrade3_add_value_1 = value
		obj.upgrade3_mod_prop_id_2 = "electricity_consumption"
		obj.upgrade3_add_value_2 = 2500
		obj.upgrade3_upgrade_cost_Concrete = 15000
		obj.upgrade3_upgrade_cost_Metals = 10000
	end
end

local upgrade_list = {}
local upgrade_list_c = 0

-- start with first upgrade unlocked
local function StartupCode()
--~ 	ex(upgrade_list)

	for i = 1, upgrade_list_c do
		local name = upgrade_list[i]
		UICity.unlocked_upgrades[name .. "_Capacity1"] = true
		UICity.unlocked_upgrades[name .. "_Capacity2"] = true
		UICity.unlocked_upgrades[name .. "_Capacity3"] = true
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

function OnMsg.ClassesPostprocess()
	-- this'll fire more than once
	table.iclear(upgrade_list)
	upgrade_list_c = 0

	local g_Classes = g_Classes
	local BuildingTemplates = BuildingTemplates
	for id, obj in pairs(BuildingTemplates) do
		if obj.group == "Dome Services" or obj.group == "Decorations"
				or obj.group == "Habitats" then
			-- first try to get number from building template (for services like parks)
			if obj.capacity and obj.capacity > 0 then
				AddUpgrades(obj, id, "capacity", obj.capacity)
				upgrade_list_c = upgrade_list_c + 1
				upgrade_list[upgrade_list_c] = id
			elseif obj.max_visitors and obj.max_visitors > 0 then
				AddUpgrades(obj, id, "max_visitors", obj.max_visitors)
				upgrade_list_c = upgrade_list_c + 1
				upgrade_list[upgrade_list_c] = id
			else
				-- get class name and class obj (needed for the cap numbers)
				id = obj.template_class
				if id == "" then
					id = obj.template_name
				end
				local cls = g_Classes[id]
				if cls then
					local value = cls.capacity or cls:GetDefaultPropertyValue("capacity")
					if value and value > 0 then
						AddUpgrades(obj, id, "capacity", value)
						upgrade_list_c = upgrade_list_c + 1
						upgrade_list[upgrade_list_c] = id
					else
						value = cls.max_visitors or cls:GetDefaultPropertyValue("max_visitors")
						if value and value > 0 then
							AddUpgrades(obj, id, "max_visitors", value)
							upgrade_list_c = upgrade_list_c + 1
							upgrade_list[upgrade_list_c] = id
						end
					end
				end
			end
		end

	end
end
