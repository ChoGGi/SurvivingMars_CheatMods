-- See LICENSE for terms

local skip_buildings = {
	-- Underground-Tec apartments capacity resets
	UndergroundApartments = true,
}

local custom_ids = {
	-- Silva's Mods:
	-- Medium Apartments - Steam Mod ID: 1565367065
	sMediumApartments = true,
	-- Hall Of Fame - Steam Mod ID: 1700393642
	RDM_HallOfFame = true,
	-- Retro Cinema - Steam Mod ID: 1442463010
	sCinema = true,
	-- Halloween Nightclub - Steam Mod ID: 1546766601
	sHalloweenNightclub = true,
	-- Toys Store - Steam Mod ID: 1588102866
	sToysStore = true,
	-- Panoramic Restaurant - Steam Mod ID: 1470492725
	sPanoramicRestaurant = true,
	-- Mega Apartment - Steam Mod ID: 1755128182
	RDM_MegaApartment = true,

	-- Skirich Mods:
	-- NASA Tai Chi Garden - Steam Mod ID: 1354299580
	NASATaiChiGarden = true,
	-- Corporate Office - Steam Mod ID: 1354299580
	NASACorporateOffice = true,

	-- Other:
	-- Space Fast Food - Steam Mod ID: 1664705963
	fastfood = true,
	-- Brothel - Steam Mod ID: 1568066596
	LH_Brothel = true,
	-- Glass House - Steam Mod ID: 1661517253
	TubularHouse = true,

	Battery_WaterFuelCell = true,
	AtomicBattery = true,
	LargeWaterTank = true,
	WaterTank = true,
	OxygenTank = true,
	OxygenTank_Large = true,
}

local function AddUpgrades(obj, id, prop, value)
	local display_cap = value
	if display_cap > 1000 then
		display_cap = display_cap / const.ResourceScale
	end

	-- of course it's only these...
	if prop == "air_capacity" or prop == "water_capacity" then
		value = value / const.ResourceScale
	end

	local elec2 = 1500
	local display_elec = 1.5

	local id_cap1 = id .. "_Capacity1"
	-- don't override built-in upgrades
	if obj.upgrade1_id == "" then
		obj.upgrade1_id = id_cap1
		obj.upgrade1_display_name = T(302535920012052, "Capacity 1")
		obj.upgrade1_icon = "UI/Icons/Upgrades/home_collective_01.tga"
		obj.upgrade1_mod_prop_id_1 = prop
		obj.upgrade1_add_value_1 = value
		if obj.electricity_consumption then
			obj.upgrade1_mod_prop_id_2 = "electricity_consumption"
			obj.upgrade1_add_value_2 = 1000
			obj.upgrade1_description = T{302535920011349,
				"+<display_cap> Capacity, +<display_elec> <icon_Power> Consumption",
				display_cap = display_cap, display_elec = 1,
			}
		else
			obj.upgrade1_description = T{302535920011350,
				"+<display_cap> Capacity",
				display_cap = display_cap,
			}
		end
		obj.upgrade1_upgrade_cost_Concrete = 5000
		obj.upgrade1_upgrade_cost_Metals = 1000
	end
	-- boost the next ones
	if obj.upgrade1_id ~= id_cap1 then
		-- add more cap if upgrade1 is taken (floatfloor for 15 instead of 15.0)
		value = floatfloor(value * 1.5)
		display_cap = floatfloor(display_cap * 1.5)
		elec2 = 2500
		display_elec = 2.5
	end

	if obj.upgrade2_id == "" then
		obj.upgrade2_id = id .. "_Capacity2"
		obj.upgrade2_display_name = T(302535920012053, "Capacity 2")
		obj.upgrade2_icon = "UI/Icons/Upgrades/home_collective_01.tga"
		obj.upgrade2_mod_prop_id_1 = prop
		obj.upgrade2_add_value_1 = value
		if obj.electricity_consumption then
			obj.upgrade2_mod_prop_id_2 = "electricity_consumption"
			obj.upgrade2_add_value_2 = elec2
			obj.upgrade2_description = T{302535920011349,
				"+<display_cap> Capacity, +<display_elec> <icon_Power> Consumption",
				display_cap = display_cap, display_elec = display_elec,
			}
		else
			obj.upgrade2_description = T{302535920011350,
				"+<display_cap> Capacity",
				display_cap = display_cap, display_elec = display_elec,
			}
		end
		obj.upgrade2_upgrade_cost_Concrete = 10000
		obj.upgrade2_upgrade_cost_Metals = 3000
	end

	if obj.upgrade3_id == "" then
		obj.upgrade3_id = id .. "_Capacity3"
		obj.upgrade3_display_name = T(302535920012054, "Capacity 3")
		obj.upgrade3_icon = "UI/Icons/Upgrades/home_collective_01.tga"
		obj.upgrade3_mod_prop_id_1 = prop
		obj.upgrade3_add_value_1 = value
		if obj.electricity_consumption then
			obj.upgrade3_mod_prop_id_2 = "electricity_consumption"
			obj.upgrade3_add_value_2 = 2500
			obj.upgrade3_description = T{302535920011349,
				"+<display_cap> Capacity, +<display_elec> <icon_Power> Consumption",
				display_cap = display_cap, display_elec = display_elec,
			}
		else
			obj.upgrade3_description = T{302535920011350,
				"+<display_cap> Capacity",
				display_cap = display_cap,
			}
		end
		obj.upgrade3_upgrade_cost_Concrete = 15000
		obj.upgrade3_upgrade_cost_Metals = 10000
	end
end

local upgrade_list = {}
local upgrade_list_c = 0

-- start with upgrades unlocked (you can hide them behind tech if you want)
local function StartupCode()
--~ 	ex(upgrade_list)

	local unlocked_upgrades = UIColony.unlocked_upgrades
	for i = 1, upgrade_list_c do
		local name = upgrade_list[i]
		unlocked_upgrades[name .. "_Capacity1"] = true
		unlocked_upgrades[name .. "_Capacity2"] = true
		unlocked_upgrades[name .. "_Capacity3"] = true
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local function BumpCount(id)
	upgrade_list_c = upgrade_list_c + 1
	upgrade_list[upgrade_list_c] = id
end

local storage_list = {
	"capacity",
	"max_visitors",
	"max_workers",
	"air_capacity",
	"water_capacity",
}
local storage_list_c = #storage_list

local function AddBuilding(id, obj, obj_ct, cls)
	-- If the template doesn't have the prop, check the class obj
	local template_id = obj.template_class
	if template_id == "" then
		template_id = obj.template_name
	end

	-- first try to get number from building template (for services like parks)
	for i = 1, storage_list_c do
		local prop = storage_list[i]
		local value = obj[prop]
		if value and value > 0 then
			AddUpgrades(obj, id, prop, value)
			AddUpgrades(obj_ct, id, prop, value)
			BumpCount(id)
			break
		-- check the cls obj
		elseif cls then
			value = cls[prop] or cls:GetDefaultPropertyValue(prop)
			if value and value > 0 then
				AddUpgrades(obj, id, prop, value)
				AddUpgrades(obj_ct, id, prop, value)
				BumpCount(id)
				break
			end
		end
	end

end

function OnMsg.ModsReloaded()
	table.iclear(upgrade_list)
	upgrade_list_c = 0

	local g_Classes = g_Classes

	local ct = ClassTemplates.Building
	local BuildingTemplates = BuildingTemplates

	for id, obj in pairs(BuildingTemplates) do
		if custom_ids[id] then
			AddBuilding(id, obj, ct[id], g_Classes[id])
		elseif not skip_buildings[id] and
			obj.group == "Dome Services" or obj.group == "Decorations"
			or obj.group == "Habitats" or obj.group == "Dome Spires"
--~ 			or obj.group == "MechanizedDepots" or obj.group == "Depots" or obj.group == "Storages"
		then
			AddBuilding(id, obj, ct[id], g_Classes[id])
		end
	end
end
