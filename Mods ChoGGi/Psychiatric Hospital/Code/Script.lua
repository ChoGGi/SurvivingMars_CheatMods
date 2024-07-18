-- See LICENSE for terms

DefineClass.ChoGGi_PsychiatricHospital = {
	__parents = {
		"Sanatorium",
	},
	max_traits = 1,
}


local mod_AddIntrovert
local mod_AddWhiner
local mod_AddReligious

local function AddExtraTraits()
	local bt = BuildingTemplates.ChoGGi_PsychiatricHospital
	local ct = ClassTemplates.Building.ChoGGi_PsychiatricHospital

	local count = 1
	if mod_AddIntrovert then
		count = count + 1
	end
	if mod_AddWhiner then
		count = count + 1
	end
	if mod_AddReligious then
		count = count + 1
	end


	if mod_AddIntrovert or mod_AddWhiner or mod_AddReligious then
		ChoGGi_PsychiatricHospital.max_traits = count
		bt.max_traits = count
		ct.max_traits = count

		local added_count = 2
		if mod_AddIntrovert then
			bt["trait" .. added_count] = "Whiner"
			ct["trait" .. added_count] = "Whiner"
			added_count = added_count + 1
		end
		if mod_AddIntrovert then
			bt["trait" .. added_count] = "Introvert"
			ct["trait" .. added_count] = "Introvert"
			added_count = added_count + 1
		end
		if mod_AddReligious then
			bt["trait" .. added_count] = "Religious"
			ct["trait" .. added_count] = "Religious"
--~ 			added_count = added_count + 1
		end

	else
		ChoGGi_PsychiatricHospital.max_traits = 1
		bt.max_traits = 1
		bt.trait2 = ""
		bt.trait3 = ""
		bt.trait4 = ""
		ct.max_traits = 1
		ct.trait2 = ""
		ct.trait3 = ""
		ct.trait4 = ""
	end

end
-- New games
OnMsg.CityStart = AddExtraTraits
-- Saved ones
OnMsg.LoadGame = AddExtraTraits

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_AddIntrovert = CurrentModOptions:GetProperty("AddIntrovert")
	mod_AddWhiner = CurrentModOptions:GetProperty("AddWhiner")
	mod_AddReligious = CurrentModOptions:GetProperty("AddReligious")

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	AddExtraTraits()
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
			"description", T(0000, "Treats Idiots using slow but effective ways, combining medicine, psychology and some unorthodox practices."),
			"max_visitors", 2,
			"trait1", "Idiot",
			"evaluation_points", 600,
			"construction_cost_Concrete", 90000,
			"construction_cost_Metals", 50000,
			"construction_cost_Polymers", 25000,

			"palette_color1", "outside_dark",
			"palette_color2", "inside_accent_medical",
			"palette_color3", "wonder_base",

			"display_icon", CurrentModPath .. "/UI/PsychiatricHospital.png",

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
	local traits = {"Idiot"}
	local c = 1

	if mod_AddIntrovert then
		c = c + 1
		traits[c] = "Introvert"
	end
	if mod_AddWhiner then
		c = c + 1
		traits[c] = "Whiner"
	end
	if mod_AddReligious then
		c = c + 1
		traits[c] = "Religious"
	end

	return traits
end

--~ function OnMsg.SelectedObjChange(obj)
--~ 	if not IsKindOf(obj, "ChoGGi_PsychiatricHospital") then
--~ 		return
--~ 	end

--~ 	-- Local is faster than global
--~ 	local TGetID = TGetID

--~ 	-- Slight delay needed
--~ 	CreateRealTimeThread(function()
--~ 		WaitMsg("OnRender")

--~ 		local content = Dialogs.Infopanel.idContent
--~ 		for i = 1, #content do
--~ 			local section = content[i]
--~ 			if TGetID(section.RolloverText) == 257506711483--[[Select a trait that is affected by this building.]]
--~ 			then
--~ 				section.FoldWhenHidden = true
--~ 				section:SetVisible(false)
--~ 				break
--~ 			end
--~ 		end
--~ 	end)
--~ end
