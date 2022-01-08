-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print("MicroG Extractor Resource: B&B DLC not installed!")
	return
end

local orig_list = BuildingTemplates.MicroGAutoExtractor.expected_exploitation_resources
local list = table.icopy(orig_list)
local count = #list

-- cycles through the list of resources
local function NextResource(current_res)
	if list[1] ~= "Default" then
		table.insert(list, 1, "Default")
		count = #list
	end

	local idx = table.find(list, current_res) or 0
	idx = (idx % count) + 1
	return list[idx]
end

local icons = {
	Default = "UI/Icons/res_overall_terraforming.tga",
	Metals = "UI/Icons/res_metal.tga",
	PreciousMinerals = "UI/Icons/res_precious_minerals.tga",
	PreciousMetals = "UI/Icons/res_precious_metals.tga",
}

function OnMsg.ClassesPostprocess()
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
			end,

			"Title", T(0000, "Select Resource"),
			"RolloverTitle", T(0000, "Select Resource"),
			"RolloverText", T(0000, "Select resource to exploit."),
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
