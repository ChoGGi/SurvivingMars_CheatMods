-- See LICENSE for terms

local IsValid = IsValid

local mod_CleanDomes
local mod_WaitForIt

-- fired when settings are changed/init
local function ModOptions()
	mod_CleanDomes = CurrentModOptions:GetProperty("CleanDomes")
	mod_WaitForIt = CurrentModOptions:GetProperty("WaitForIt")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end


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
	-- skip if domes not opened
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
						print("cleaned",trans(dirty:GetDisplayName()))
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

	if BuildingTemplates.ChoGGi_IndoorTribby then
		return
	end

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

		"display_name", T(4818, --[[BuildingTemplate TriboelectricScrubber display_name]] "Triboelectric Scrubber"),
		"display_name_pl", T(5299, --[[BuildingTemplate TriboelectricScrubber display_name_pl]] "Triboelectric Scrubbers"),
		"description", T(5300, --[[BuildingTemplate TriboelectricScrubber description]] "Emits pulses which reduce the Dust accumulated on buildings in its range."),
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


	-- lock tech behind tribby tech
	local tech = TechDef.TriboelectricScrubbing
	tech[#tech+1] = PlaceObj("Effect_TechUnlockBuilding", {
		Building = "ChoGGi_IndoorTribby",
	})


	local xtemplate = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_ChoGGi_IndoorTribby", true)

	table.insert(xtemplate, 1,
		PlaceObj("XTemplateTemplate", {
			"ChoGGi_Template_ChoGGi_IndoorTribby", true,
			"__context_of_kind", "ChoGGi_IndoorTribby",
			"__template", "InfopanelSection",

			"RolloverText", T(488709956734, --[[XTemplate customTriboelectricScrubber RolloverText]] "Increasing the area of effect will greatly increase the power consumption of the building.<newline><newline>Charging time<right><em><ChargeTime> h<em><newline><left>Service range<right><SelectionRadiusScale> hexes"),
			"RolloverHintGamepad", T(253409130526, --[[XTemplate customTriboelectricScrubber RolloverHintGamepad]] "<LB> / <RB>    change service radius"),
			"Title", T(994862568830, --[[XTemplate customTriboelectricScrubber Title]] "Service area"),
			"Icon", "UI/Icons/Sections/facility.tga",

		}, {
			PlaceObj("XTemplateTemplate", {
				"__template", "InfopanelSlider",
				"BindTo", "UIRange",
			}),
		})
	)

end
