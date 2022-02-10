-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function fake_SingleResourceProducer_Produce()
	return 0
end

function MoholeMine:ChoGGi_ToggleProductionResource(res)
	local prod = self.producers[res]

	if type(prod.ChoGGi_ChoOrig_Produce) == "function" then
		prod.Produce = prod.ChoGGi_ChoOrig_Produce
		prod.ChoGGi_ChoOrig_Produce = nil
		return true
	else
		prod.ChoGGi_ChoOrig_Produce = prod.Produce
		prod.Produce = fake_SingleResourceProducer_Produce
		return false
	end

end

--~ function OnMsg.ClassesGenerate()
function OnMsg.ClassesPostprocess()
	local xtemplate = XTemplates.ipBuilding[1]

	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_WonderCheats_LimitMetals", true)

	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_WonderCheats_LimitMetals",
		"ChoGGi_Template_WonderCheats_LimitMetals", true,
		"__context_of_kind", "MoholeMine",
		"__template", "InfopanelButton",
		"__condition", function()
			return mod_EnableMod
		end,

		"RolloverTitle", T(302535920011456, "Toggle Metals"),
		"RolloverText", T(302535920011455, "Allow Mohole to produce metals."),
		"Icon", "UI/Icons/ColonyControlCenter/metals_on.tga",

		"OnContextUpdate", function(self, context)
			if context.producers.Metals.ChoGGi_ChoOrig_Produce then
				self:SetIcon("UI/Icons/ColonyControlCenter/metals_off.tga")
			else
				self:SetIcon("UI/Icons/ColonyControlCenter/metals_on.tga")
			end
		end,

		"OnPress", function(self)
			local context = self.context
			context:ChoGGi_ToggleProductionResource("Metals")
			ObjModified(context)
		end,
	})

	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_WonderCheats_LimitRareMetals", true)
	xtemplate[#xtemplate+1] = PlaceObj("XTemplateTemplate", {
		"Id" , "ChoGGi_Template_WonderCheats_LimitRareMetals",
		"ChoGGi_Template_WonderCheats_LimitRareMetals", true,
		"__context_of_kind", "MoholeMine",
		"__template", "InfopanelButton",
		"__condition", function()
			return mod_EnableMod
		end,

		"RolloverTitle", T(302535920011511, "Toggle Rare Metals"),
		"RolloverText", T(302535920011512, "Allow Mohole to produce rare metals."),
		"Icon", "UI/Icons/ColonyControlCenter/preciousmetals_on.tga",

		"OnContextUpdate", function(self, context)
			if context.producers.PreciousMetals.ChoGGi_ChoOrig_Produce then
				self:SetIcon("UI/Icons/ColonyControlCenter/preciousmetals_off.tga")
			else
				self:SetIcon("UI/Icons/ColonyControlCenter/preciousmetals_on.tga")
			end
		end,

		"OnPress", function(self)
			local context = self.context
			context:ChoGGi_ToggleProductionResource("PreciousMetals")
			ObjModified(context)
		end,
	})

end
