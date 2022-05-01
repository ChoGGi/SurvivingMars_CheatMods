-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed!")
	return
end

local table = table

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	if CurrentModOptions:GetProperty("NoPower") then
		ClassTemplates.Building.MicroGAutoExtractor.disable_electricity_consumption = 1
	else
		ClassTemplates.Building.MicroGAutoExtractor.disable_electricity_consumption = 0
	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local orig_list = BuildingTemplates.MicroGAutoExtractor.expected_exploitation_resources
local custom_list = table.icopy(orig_list)
local count = #custom_list

-- cycles through the list of resources
local function NextResource(current_res)
	if custom_list[1] ~= "Default" then
		table.insert(custom_list, 1, "Default")
		count = #custom_list
	end

	local idx = table.find(custom_list, current_res) or 0
	return custom_list[(idx % count) + 1]
end

local icons = {
	Default = "UI/Icons/res_overall_terraforming.tga",
	Metals = "UI/Icons/res_metal.tga",
	PreciousMinerals = "UI/Icons/res_precious_minerals.tga",
	PreciousMetals = "UI/Icons/res_precious_metals.tga",
}
local text = {
	Default = 1000121--[[Default]],
	Metals = 3514--[[Metals]],
	PreciousMinerals = 229258768953--[[Exotic Minerals]],
	PreciousMetals = 4139--[[Rare Metals]],
}

function OnMsg.ClassesPostprocess()

	-- if no deposit of selected resource, then change to any resource
	local ChoOrig_AutomaticMicroGExtractor_OnDepositDepleted = AutomaticMicroGExtractor.OnDepositDepleted
	function AutomaticMicroGExtractor:OnDepositDepleted(...)
		--
		if not self:ConnectToDeposit() then
			self.ChoGGi_Resource = "Default"
			self.expected_exploitation_resources = orig_list
			self:ConnectToDeposit()
		end
		return ChoOrig_AutomaticMicroGExtractor_OnDepositDepleted(self, ...)
	end

	-- add toggle button to selection panel

	local xtemplate = XTemplates.ipBuilding[1]
	-- check for and remove existing template
	ChoGGi.ComFuncs.RemoveXTemplateSections(xtemplate, "ChoGGi_Template_MicroGExtractorResource_ResourceToggle", true)

	table.insert(xtemplate, 1,
		PlaceObj("XTemplateTemplate", {
			"Id" , "ChoGGi_Template_MicroGExtractorResource_ResourceToggle",
			"ChoGGi_Template_MicroGExtractorResource_ResourceToggle", true,
			"comment", "something something",
			"__context_of_kind", "AutomaticMicroGExtractor",
			-- main button
			"__template", "InfopanelButton",
			-- section button
			"OnContextUpdate", function(self, context)
				if not context.ChoGGi_Resource then
					context.ChoGGi_Resource = "Default"
				end
				self:SetIcon(icons[context.ChoGGi_Resource] or icons.Default)
				if self.idIcon.ScaleModifier:x() ~= 2000 then
					self.idIcon:SetScaleModifier(point(2000, 2000))
				end

				self:SetRolloverText(T(0000, "Select resource to exploit: ") .. T(text[context.ChoGGi_Resource] or text.Default))
			end,

			"RolloverTitle", T(0000, "Select Resource"),
			"RolloverText", T(0000, "Select resource to exploit: "),
			"RolloverHint", T(0000, "<left_click> Select"),
			"Icon", icons.Default,

			"OnPress", function(self)
				local context = self.context
				-- if nothing is selected than we've yet to change anything
				if not context.ChoGGi_Resource then
					context.ChoGGi_Resource = "Default"
				end
				-- cycle away
				local new_resource = NextResource(context.ChoGGi_Resource)
				context.ChoGGi_Resource = new_resource
				-- "Default" is default operation of extractor
				if new_resource == "Default" then
					context.expected_exploitation_resources = orig_list
				else
					context.expected_exploitation_resources = {new_resource}
				end
				-- update connected deposit to new res
				context:ConnectToDeposit()
				ObjModified(context)
			end,
		})
	)

end
