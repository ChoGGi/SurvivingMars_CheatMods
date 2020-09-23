-- See LICENSE for terms

DefineClass.MedicalSanatorium = {
	__parents = {
		"Sanatorium",
		"InteriorAmbientLife"
	},
	flags = {efWalkable = true},
	interior = {
		"InfirmaryInterior"
	},

}

function OnMsg.ClassesPostprocess()
	if BuildingTemplates.MedicalSanatorium then
		return
	end

	PlaceObj("BuildingTemplate", {
		"Id", "MedicalSanatorium",
		"template_class", "MedicalSanatorium",
		"dome_required", true,

		"construction_cost_Concrete", 30000,
		"construction_cost_Metals", 20000,
		"construction_cost_Polymers", 10000,
		"maintenance_resource_type", "Polymers",
		"maintenance_resource_amount", 2000,

		"build_points", 30000,
		"build_category", "Dome Services",

		"upgrade1_id", "Sanatorium_BehavioralMelding",
		"upgrade1_display_name", T(5243, "Behavioral Melding"),
		"upgrade1_description", T(5244, "Replaces flaws with Perks for visitors."),
		"upgrade1_icon", "UI/Icons/Upgrades/behavioral_melding_01.tga",
		"upgrade1_upgrade_cost_Polymers", 10000,
		"upgrade1_upgrade_cost_Electronics", 10000,

		"display_name", "Medical Sanatorium",
		"display_name_pl", "Medical Sanatoriums",
		"description", T(5246, "Treats Colonists for flaws through advanced and (mostly) humane medical practices."),
		"display_icon", "UI/Icons/Buildings/sanatorium.tga",

		"encyclopedia_id", "Sanatorium",
		"encyclopedia_image", "UI/Encyclopedia/Sanatorium.tga",

		"demolish_sinking", range(8, 18),
		"demolish_tilt_angle", range(600, 900),
		"demolish_debris", 80,
		"entity", "Infirmary",
		"palette_color1", "inside_base",
		"palette_color2", "inside_accent_medical",
		"palette_color3", "inside_accent_service",
		"palette_color4", "inside_metal",

		"entity2", "InfirmaryCP3",
		"entitydlc2", "contentpack3",
		"palette2_color1", "inside_accent_medical",
		"palette2_color2", "inside_base",
		"palette2_color3", "inside_accent_service",
		"palette2_color4", "inside_metal",
		"label1", "InsideBuildings",

		"electricity_consumption", 20000,
		"enabled_shift_1", false,
		"enabled_shift_3", false,
		"max_visitors", 4,
		"evaluation_points", 200,
		"trait1", "Gambler",
		"trait2", "Alcoholic",
		"trait3", "Glutton"
	})
end
