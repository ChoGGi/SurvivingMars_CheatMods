-- See LICENSE for terms

DefineClass.ChoGGi_ExamplePowerGen = {
	__parents = {
		"Building",
		"ElectricityProducer",
		"OutsideBuildingWithShifts",
		"HasConsumption",
	},
}

--~ function ChoGGi_ExamplePowerGen:BuildingUpdate(delta, day, hour)
function ChoGGi_ExamplePowerGen:BuildingUpdate()
	self:Consume_Internal(self.consumption_amount)
end

function OnMsg.ClassesPostprocess()
	if BuildingTemplates.ChoGGi_ExamplePowerGen then
		return
	end

	PlaceObj("BuildingTemplate", {
		"Id", "ChoGGi_ExamplePowerGen",
		"template_class", "ChoGGi_ExamplePowerGen",
		"construction_cost_Concrete", 1000,
		"construction_cost_Metals", 1000,
		"construction_cost_MachineParts", 1000,
		"palette_color1", "outside_base",
		"palette_color2", "inside_accent_factory",
		"palette_color3", "rover_base",

		"maintenance_resource_type", "MachineParts",
		"maintenance_resource_amount", 1000,
		"consumption_resource_type", "WasteRock",
		"consumption_max_storage", 20000,
		"consumption_amount", 1000,

		"electricity_production", 10000,

		"display_name", T(0, "Example"),
		"display_name_pl", T(0, "Examples"),
		"description", T(0, "Example description"),
		"display_icon", "UI/Icons/Buildings/placeholder.tga",
		"entity", "ElectronicsFactory",
		"build_category", "ChoGGi",
		"Group", "ChoGGi",
		"encyclopedia_exclude", true,
		"demolish_sinking", range(5, 10),
		"demolish_tilt_angle", range(720, 1020),
		"demolish_debris", 80,
	})

end
