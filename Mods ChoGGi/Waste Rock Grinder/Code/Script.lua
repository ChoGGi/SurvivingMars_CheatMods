-- See LICENSE for terms

DefineClass.ChoGGi_WasteRockGrinder = {
	__parents = {
		"WasteRockProcessor",
    "DustGenerator",
	},
  building_update_time = const.HourDuration,
  stockpile_spots1 = {
    "Resourcepile1"
  },
  additional_stockpile_params1 = {
    apply_to_grids = false,
    has_platform = true,
    snap_to_grid = false,
    priority = 2,
    additional_supply_flags = const.rfSpecialDemandPairing
  },

	dust_range = 4,
}

local produced = 1 * const.ResourceScale

function ChoGGi_WasteRockGrinder:BuildingUpdate()
--~ 	self:ProduceWasteRock(produced, "Very Low")

  if self.wasterock_producer then
    self.wasterock_producer:Produce(produced)
    return self.wasterock_producer:IsStorageFull()
  end

end

function ChoGGi_WasteRockGrinder:GameInit()
	self:SetColorModifier(-12374251)

	-- -128 to 127
	-- object, 1-4 , Color, Roughness, Metallic
	self:SetColorizationMaterial(1, -9175040, -128, 120)
	self:SetColorizationMaterial(2, -5987164, 120, 20)
	self:SetColorizationMaterial(3, -5694693, -128, 48)

end

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.ChoGGi_WasteRockGrinder then
		PlaceObj("BuildingTemplate", {
			"maintenance_resource_type", "Concrete",
--~ 			"consumption_resource_type", "Concrete",
--~ 			"consumption_max_storage", 20000,
--~ 			"consumption_amount", 0,
			"resource_produced1", "WasteRock",
--~ 			"production_per_day1", 25 * const.ResourceScale,

			"stockpile_class1", "WasteRockStockpile",

			"Id", "ChoGGi_WasteRockGrinder",
			"template_class", "ChoGGi_WasteRockGrinder",
			"palette_color1", "outside_base",
			"palette_color2", "inside_base",
			"palette_color3", "rover_base",

			"dome_forbidden", true,
			"display_name", T(302535920012011, "Waste Rock Grinder"),
			"display_name_pl", T(302535920012012, "Waste Rock Grinders"),
			"description", T(302535920012013, "Grinds dirt. Produces waste rock."),

			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"encyclopedia_exclude", true,


			"construction_cost_Metals", 12000,
			"construction_cost_MachineParts", 2000,
			"build_points", 5000,
			"is_tall", true,
			"dome_forbidden", true,
			"force_extend_bb_during_placement_checks", 12000,
			"upgrade1_id", "WasteRockProcessor_FactoryAI",
			"upgrade1_display_name", T(388446725632,  "Factory AI"),
			"upgrade1_description", T(828188588588, "+<upgrade1_mul_value_1>% Production."),
			"upgrade1_icon", "UI/Icons/Upgrades/factory_ai_01.tga",
			"upgrade1_upgrade_cost_Electronics", 5000,
			"upgrade1_upgrade_cost_MachineParts", 2000,
			"upgrade1_mod_label_1", "WasteRockProcessor",
			"upgrade1_mod_prop_id_1", "production_per_day1",
			"upgrade1_mul_value_1", 20,
			"upgrade2_id", "WasteRockProcessor_Automation",
			"upgrade2_display_name", T(672501118965,  "Automation"),
			"upgrade2_description", T(262068965523,  "Decreases Workplaces by <abs(upgrade2_add_value_1)>."),
			"upgrade2_icon", "UI/Icons/Upgrades/automation_01.tga",
			"upgrade2_upgrade_cost_Polymers", 5000,
			"upgrade2_upgrade_cost_Electronics", 5000,
			"upgrade2_mod_label_1", "WasteRockProcessor",
			"upgrade2_mod_prop_id_1", "max_workers",
			"upgrade2_add_value_1", -2,
			"upgrade3_id", "WasteRockProcessor_Amplify",
			"upgrade3_display_name", T(666499249900, "Amplify"),
			"upgrade3_description", T(665321230600, "+<upgrade3_mul_value_1>% Production; +<power(upgrade3_add_value_2)> Consumption."),
			"upgrade3_icon", "UI/Icons/Upgrades/amplify_01.tga",
			"upgrade3_upgrade_cost_Polymers", 5000,
			"upgrade3_mod_label_1", "WasteRockProcessor",
			"upgrade3_mod_prop_id_1", "production_per_day1",
			"upgrade3_mul_value_1", 25,
			"upgrade3_mod_label_2", "WasteRockProcessor",
			"upgrade3_mod_prop_id_2", "electricity_consumption",
			"upgrade3_add_value_2", 20000,
			"maintenance_threshold_base", 150000,
			"display_icon", "UI/Icons/Buildings/waste_rock_processor.tga",
			"build_pos", 8,
			"entity", "WasteRockProcessor",
			"label1", "OutsideBuildings",
			"label2", "OutsideBuildingsTargets",
			"demolish_sinking", range(20, 20),
			"demolish_tilt_angle", range(600, 600),
			"demolish_debris", 0,
		})
	end
end
