-- See LICENSE for terms

local gagarin = g_AvailableDlc.gagarin

DefineClass.ChoGGi_DroneBuilding = {
	__parents = {"BaseRoverBuilding"},
	rover_class = "Drone",
}
if gagarin then
	DefineClass.ChoGGi_FlyingDroneBuilding = {
		__parents = {"BaseRoverBuilding"},
		rover_class = "FlyingDrone",
	}
end

function OnMsg.ClassesPostprocess()
	if BuildingTemplates.ChoGGi_DroneBuilding then
		return
	end

	PlaceObj("BuildingTemplate", {

		-- added, not uploaded
		"disabled_in_environment1", "",
		"disabled_in_environment2", "",
		"disabled_in_environment3", "",
		"disabled_in_environment4", "",

		"Id", "ChoGGi_DroneBuilding",
		"template_class", "ChoGGi_DroneBuilding",
		"construction_cost_Electronics", 2500,
		"build_points", 1000,
		"count_as_building", false,

		"build_pos", 0,
		"build_category", "Rovers",
		"Group", "Rovers",
		"display_name", Drone.display_name,
		"display_name_pl", Drone.display_name_pl,
		"description", Drone.description,
		"display_icon", Drone.display_icon,
		"entity", "DroneMaintenance",
	})

	if not gagarin then
		return
	end
	PlaceObj("BuildingTemplate", {
		"Id", "ChoGGi_FlyingDroneBuilding",
		"template_class", "ChoGGi_FlyingDroneBuilding",
		"construction_cost_Electronics", 2500,
		"build_points", 1000,
		"count_as_building", false,

		"build_pos", 0,
		"build_category", "Rovers",
		"Group", "Rovers",
		"display_name", FlyingDrone.display_name,
		"display_name_pl", FlyingDrone.display_name_pl,
		"description", FlyingDrone.description,
		"display_icon", FlyingDrone.display_icon,
		"entity", "DroneJapanFlying",
		})
end

local function UpdateCost()
	local bt = BuildingTemplates
	-- not sure if ct is needed and too lazy to check
	local ct = ClassTemplates.Building
	bt.ChoGGi_DroneBuilding.construction_cost_Electronics = false
	bt.ChoGGi_DroneBuilding.construction_cost_Metals = 2500
	ct.ChoGGi_DroneBuilding.construction_cost_Electronics = false
	ct.ChoGGi_DroneBuilding.construction_cost_Metals = 2500

	if not gagarin then
		return
	end
	bt.ChoGGi_FlyingDroneBuilding.construction_cost_Electronics = false
	bt.ChoGGi_FlyingDroneBuilding.construction_cost_Metals = 2500
	ct.ChoGGi_FlyingDroneBuilding.construction_cost_Electronics = false
	ct.ChoGGi_FlyingDroneBuilding.construction_cost_Metals = 2500
end

local function StartupCode()
	if IsTechResearched("PrintedElectronics") then
		UpdateCost()
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

function OnMsg.TechResearched(tech_id)
	if tech_id == "PrintedElectronics" then
		UpdateCost()
	end
end
