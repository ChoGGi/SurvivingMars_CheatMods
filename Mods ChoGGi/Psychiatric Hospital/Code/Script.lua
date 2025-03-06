-- See LICENSE for terms

DefineClass.ChoGGi_PsychiatricHospital = {
	__parents = {
		"Sanatorium",
	},
	-- How many sections show up in selection panel
	max_traits = 3,
}

local mod_options = {}
local function BuildList(traits)
	for i = 1, #traits do
		mod_options[traits[i].id] = false
	end
end
local traits = Presets.TraitPreset
BuildList(traits.Positive)
BuildList(traits.Negative)
BuildList(traits.other)

local function UpdateTraits()
	local bt = BuildingTemplates.ChoGGi_PsychiatricHospital
	local ct = ClassTemplates.Building.ChoGGi_PsychiatricHospital

	local count = 0

	for _, value in pairs(mod_options) do
		if value then
			count = count + 1
		end
	end


	if count > 0 then
		ChoGGi_PsychiatricHospital.max_traits = 3
		bt.max_traits = 3
		ct.max_traits = 3

		local added_count = 0

		for id, value in pairs(mod_options) do
			if value then
				added_count = added_count + 1
				bt["trait" .. added_count] = id
				ct["trait" .. added_count] = id
			end
		end

	else
		ChoGGi_PsychiatricHospital.max_traits = 0
		bt.max_traits = 0
		ct.max_traits = 0

		for i = 1, 40 do
			bt["trait" .. i] = nil
			ct["trait" .. i] = nil
		end

--~ 		bt.trait1 = false
--~ 		bt.trait2 = false
--~ 		bt.trait3 = false
--~ 		bt.trait4 = false
--~ 		ct.trait1 = false
--~ 		ct.trait2 = false
--~ 		ct.trait3 = false
--~ 		ct.trait4 = false
	end

end
-- New games
OnMsg.CityStart = UpdateTraits
-- Saved ones
OnMsg.LoadGame = UpdateTraits

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions

	for id in pairs(mod_options) do
		mod_options[id] = options:GetProperty("Trait_" .. id)
	end
--~ 	ex(mod_options)

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	UpdateTraits()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

function OnMsg.ClassesPostprocess()
	if not BuildingTemplates.ChoGGi_PsychiatricHospital then
		local s = BuildingTemplates.Sanatorium

		PlaceObj("BuildingTemplate", {
			"Id", "ChoGGi_PsychiatricHospital",
			"template_class", "ChoGGi_PsychiatricHospital",

			-- https://github.com/surviving-mars/SurvivingMars/blob/master/Data/BuildingTemplate.lua

			"display_name", T(0000, "Psychiatric Hospital"),
			"display_name_pl", T(0000, "Psychiatric Hospitals"),
			"max_visitors", 2,
--~ 			"trait1", "Idiot",
			"evaluation_points", 600,
			"construction_cost_Concrete", 90000,
			"construction_cost_Metals", 50000,
			"construction_cost_Polymers", 25000,

			"palette_color1", "outside_dark",
			"palette_color2", "inside_accent_medical",
			"palette_color3", "wonder_base",

			"display_icon", CurrentModPath .. "/UI/PsychiatricHospital.png",

--~ 			"description", T(0000, "Treats Idiots using slow but effective ways, combining medicine, psychology and some unorthodox practices."),
			"description", s.description,
			"Group", s.Group,
			"build_points", s.build_points,
			"require_prefab", s.require_prefab,
			"is_tall", s.is_tall,
			"dome_required", s.dome_required,
			"dome_spot", s.dome_spot,
			"achievement", s.achievement,
			"upgrade1_id", s.upgrade1_id,
			"upgrade1_display_name", s.upgrade1_display_name,
			"upgrade1_description", s.upgrade1_description,
			"upgrade1_icon", s.upgrade1_icon,
			"upgrade1_upgrade_cost_Polymers", s.upgrade1_upgrade_cost_Polymers,
			"upgrade1_upgrade_cost_Electronics", s.upgrade1_upgrade_cost_Electronics,
			"maintenance_resource_type", s.maintenance_resource_type,
			"maintenance_resource_amount", s.maintenance_resource_amount,
			"build_category", s.build_category,
			"build_pos", s.build_pos,
			"entity", s.entity,
			"encyclopedia_id", s.encyclopedia_id,
			"encyclopedia_image", s.encyclopedia_image,
			"label1", s.label1,
			"demolish_sinking", s.demolish_sinking,
			"electricity_consumption", s.electricity_consumption,
			"enabled_shift_1", s.enabled_shift_1,
			"enabled_shift_3", s.enabled_shift_3,
		})
	end
end

-- Table of cureable traits
function ChoGGi_PsychiatricHospital:GetSanatoriumTraits()
	local traits = {}
	local c = 0

	for id, value in pairs(mod_options) do
		if value then
			c = c + 1
			traits[c] = id
		end
	end

	return traits
end
