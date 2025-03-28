-- See LICENSE for terms

local IsValid = IsValid

local mod_CleanDomes
local mod_WaitForIt

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_CleanDomes = CurrentModOptions:GetProperty("CleanDomes")
	mod_WaitForIt = CurrentModOptions:GetProperty("WaitForIt")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

DefineClass.ChoGGi_IndoorTribby = {
	__parents = {
		"TriboelectricScrubber",
	},
}

function ChoGGi_IndoorTribby:GameInit()
	self:SetColorModifier(-12374251)

	-- -128 to 127
	-- object, 1-4 , Color, Roughness, Metallic
	self:SetColorizationMaterial(1, -9175040, -128, 120)
	self:SetColorizationMaterial(2, -5987164, 120, 20)
	self:SetColorizationMaterial(3, -2694693, -128, -120)
end

function ChoGGi_IndoorTribby:CleanBuildings()
	if not self.working then
		return
	end

	if mod_CleanDomes and IsValid(self.parent_dome) then
		self.parent_dome:AccumulateMaintenancePoints(-self.dust_clean)
	end

	self:ForEachDirtyInRange(function(dirty, self)
		if dirty:IsKindOf("Building") then
			if dirty ~= self then
				if dirty:IsKindOf("DustGridElement") then
					dirty:AddDust(-self.dust_clean)
				elseif dirty.parent_dome then
					-- don't clean inside if dome isn't opened
					if not mod_WaitForIt
						or mod_WaitForIt and dirty.parent_dome.open_air
					then
						dirty:AccumulateMaintenancePoints(-self.dust_clean)
					end
				end
			end
		elseif dirty:IsKindOf("DroneBase") then
			dirty:AddDust(-self.dust_clean)
		end
	end, self)
end

function OnMsg.ClassesPostprocess()

	if not BuildingTemplates.ChoGGi_IndoorTribby then
		PlaceObj("BuildingTemplate", {
			"Id", "ChoGGi_IndoorTribby",
			"template_class", "ChoGGi_IndoorTribby",
			"construction_cost_Metals", 15000,
			"construction_cost_Electronics", 5000,
			"maintenance_resource_type", "Electronics",
			"maintenance_threshold_base", 50000,
			"palette_color1", "electro_accent_1",
			"palette_color2", "electro_base",
			"palette_color3", "inside_accent_2",

			"dome_forbidden", false,
			"dome_required", true,

			"disabled_in_environment1", "",
			"disabled_in_environment2", "",
			"disabled_in_environment3", "",
			"disabled_in_environment4", "",

			"display_name", T(302535920011748, "Indoor") .. " " .. T(4818,  "Triboelectric Scrubber"),
			"display_name_pl", T(302535920011748, "Indoor") .. " " .. T(5299, "Triboelectric Scrubbers"),
			"description", T(5300, "Emits pulses which reduce the Dust accumulated on buildings in its range."),
			"display_icon", "UI/Icons/Buildings/triboelectric_schrubbe.tga",
			"entity", "TriboelectricScrubber",
			"build_category", "ChoGGi",
			"Group", "ChoGGi",
			"encyclopedia_id", "TriboelectricScrubber",
			"encyclopedia_image", "UI/Encyclopedia/TriboelectricScrubber.tga",
			"show_range_all", true,
			"label1", "OutsideBuildings",
			"label2", "OutsideBuildingsTargets",
			"demolish_sinking", range(5, 10),
			"electricity_consumption", 1800,
			"dust_clean", 8000,
			"build_points", 2000,
			"is_tall", true,
		})

	end

	-- lock tech behind tribby tech
	local tech = TechDef.TriboelectricScrubbing
	if not table.find(tech, "Building", "ChoGGi_IndoorTribby") then
		tech[#tech+1] = PlaceObj("Effect_TechUnlockBuilding", {
			Building = "ChoGGi_IndoorTribby",
		})
	end

	local xtemplate = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi_Funcs.Common.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_ChoGGi_IndoorTribby", true)

	table.insert(xtemplate, 2,
		PlaceObj("XTemplateTemplate", {
			"ChoGGi_Template_ChoGGi_IndoorTribby", true,
			"__context_of_kind", "ChoGGi_IndoorTribby",
			"__template", "InfopanelSection",

			"RolloverText", T(488709956734, "Increasing the area of effect will greatly increase the power consumption of the building.<newline><newline>Charging time<right><em><ChargeTime> h<em><newline><left>Service range<right><SelectionRadiusScale> hexes"),
			"RolloverHintGamepad", T(253409130526, "<LB> / <RB>    change service radius"),
			"Title", T(994862568830, "Service area"),
			"Icon", "UI/Icons/Sections/facility.tga",

		}, {
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelSlider",
				"BindTo", "UIRange",
			}),
		})
	)

end
