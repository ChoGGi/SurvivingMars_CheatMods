-- See LICENSE for terms

local mod_CropsNeverFail
local mod_ConstantSoilQuality

local function UpdateSoilQuality()
	if mod_ConstantSoilQuality > 0 then
		local objs = UICity.labels.Farm or ""
		for i = 1, #objs do
			local obj = objs[i]
			if not obj.hydroponic then
				obj:SetSoilQuality(0)
			end
		end
	end
end

-- fired when settings are changed/init
local function ModOptions()
	mod_CropsNeverFail = CurrentModOptions:GetProperty("CropsNeverFail")
	mod_ConstantSoilQuality = CurrentModOptions:GetProperty("ConstantSoilQuality") * const.SoilQualityScale

	-- make sure we're ingame
	if not UICity then
		return
	end

	UpdateSoilQuality()
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.CityStart = UpdateSoilQuality
OnMsg.LoadGame = UpdateSoilQuality

local orig_Farm_CalcExpectedProduction = Farm.CalcExpectedProduction
function Farm:CalcExpectedProduction(idx, ...)
	local amount = orig_Farm_CalcExpectedProduction(self, idx, ...)

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

local orig_Farm_SetSoilQuality = Farm.SetSoilQuality
function Farm:SetSoilQuality(value, ...)
	if self.hydroponic then
		return
	end

	if mod_ConstantSoilQuality > 0 then
		value = mod_ConstantSoilQuality
	end
	return orig_Farm_SetSoilQuality(self, value, ...)
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
