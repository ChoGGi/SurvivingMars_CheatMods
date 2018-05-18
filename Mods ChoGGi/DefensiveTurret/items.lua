return {
PlaceObj("ModItemBuildingTemplate", {
  "name", "DefenceTower+",
  "template_class", "DefenceTower",
  "construction_cost_Metals", 10000,
  "construction_cost_Electronics", 5000,
  "build_points", 500,
  "is_tall", true,
  "dome_forbidden", true,
  "maintenance_resource_type", "Electronics",
  "maintenance_threshold_base", 50000,
  "display_name", T({6984, "Defensive Turret+"}),
  "display_name_pl", T({6985, "Defensive Turrets"}),
  "description", T({6986, "A laser-targeting defense structure. Protect nearby buildings from meteors. Can attack enemy vehicles at extreme range."}),
  "build_category", "Infrastructure",
  "display_icon", "UI/Icons/Buildings/defense_turret.tga",
  "build_pos", 12,
  "entity", "DefenceTurret",
  "show_range_all", true,
  "encyclopedia_exclude", true,
  "label1", "OutsideBuildings",
  "palettes", "DefenceTurret",
  "demolish_sinking", range(5, 15),
  "demolish_debris", 85,
  "electricity_consumption", 10000,
  "reload_time", 3000
}),

}
