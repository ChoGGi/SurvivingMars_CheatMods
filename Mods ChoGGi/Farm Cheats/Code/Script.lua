-- See LICENSE for terms

local ToggleWorking = ChoGGi.ComFuncs.ToggleWorking

local mod_CropsNeverFail
local mod_ConstantSoilQuality
local mod_MechFarming
local mod_MechPerformance

local function UpdateFarms()
	local objs = UIColony.city_labels.labels.Farm or ""
	for i = 1, #objs do
		local obj = objs[i]

		if mod_ConstantSoilQuality > 0 and not obj.hydroponic then
			-- 0 because it doesn't matter (see func below)
			obj:SetSoilQuality(0)
		end

		if mod_MechFarming then
			obj.max_workers = 0
			obj.automation = 1
			obj.auto_performance = mod_MechPerformance or 100
			ToggleWorking(obj)
		else
			obj.max_workers = nil
			obj.automation = nil
			obj.auto_performance = nil
		end

		ToggleWorking(obj)
	end
end
OnMsg.CityStart = UpdateFarms
OnMsg.LoadGame = UpdateFarms

-- fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_CropsNeverFail = CurrentModOptions:GetProperty("CropsNeverFail")
	mod_ConstantSoilQuality = CurrentModOptions:GetProperty("ConstantSoilQuality") * const.SoilQualityScale
	mod_MechFarming = CurrentModOptions:GetProperty("MechFarming")
	mod_MechPerformance = CurrentModOptions:GetProperty("MechPerformance")

	-- make sure we're in-game
	if not UIColony then
		return
	end

	UpdateFarms()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_Farm_CalcExpectedProduction = Farm.CalcExpectedProduction
function Farm:CalcExpectedProduction(idx, ...)
	local amount = ChoOrig_Farm_CalcExpectedProduction(self, idx, ...)

	if mod_CropsNeverFail and amount == 0 then
		-- check if there's a crop and abort if not
		idx = idx or self.current_crop
		local crop = self.selected_crop[idx]
		crop = crop and CropPresets[crop]
		if not crop then
			return 0
		end
		-- there's a crop so ignore the fail and give 'em something
		local output = (self.city or UICity):Random(crop.FoodOutput)
		if output < 1001 then
			output = 1000
		end

		return output
	end

	return amount
end

local ChoOrig_Farm_SetSoilQuality = Farm.SetSoilQuality
function Farm:SetSoilQuality(value, ...)
	if self.hydroponic then
		return
	end

	if mod_ConstantSoilQuality > 0 then
		value = mod_ConstantSoilQuality
	end
	return ChoOrig_Farm_SetSoilQuality(self, value, ...)
end

function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_Farm_InstantHarvest", true)

	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_Farm_InstantHarvest",
		"ChoGGi_Template_Farm_InstantHarvest", true,
		"__context_of_kind", "Farm",
		-- main button
		"__template", "InfopanelButton",

		"Title", T(302535920011849, "Quick Harvest"),
		"RolloverTitle", T(302535920011849, "Quick Harvest"),
		"RolloverText", T(302535920011850, "Quickly harvest current crop."),
		"Icon", "UI/Icons/IPButtons/unload.tga",

		"OnPress", function (self)
			local context = self.context
			-- change growth time to now
			context.harvest_planted_time = 1

			-- force an update instead of waiting
			context:BuildingUpdate()

			ObjModified(context)
		end,
	})

end
