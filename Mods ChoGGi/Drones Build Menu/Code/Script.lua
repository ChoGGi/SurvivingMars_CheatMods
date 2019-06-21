-- See LICENSE for terms

DefineClass.ChoGGi_DroneBuilding = {
	__parents = {"BaseRoverBuilding"},
	rover_class = "Drone",
}
DefineClass.ChoGGi_FlyingDroneBuilding = {
	__parents = {"BaseRoverBuilding"},
	rover_class = "FlyingDrone",
}

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.ChoGGi_DroneBuilding then
		PlaceObj("BuildingTemplate", {
			"Id", "ChoGGi_DroneBuilding",
			"template_class", "ChoGGi_DroneBuilding",
			"construction_cost_Electronics", 2500,
--~ 			"construction_cost_Electronics", 1,
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
end
