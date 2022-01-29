-- See LICENSE for terms

local T = T

-- add action to GameShortcuts
function OnMsg.ClassesPostprocess()
	-- If action exists then replace it, otherwise add to the end
	local GameShortcuts = XTemplates.GameShortcuts
	local idx = table.find(GameShortcuts, "ActionId", "actionColonyOverview")
	-- add the shortcut
	GameShortcuts[idx or #GameShortcuts+1] = PlaceObj("XTemplateAction", {
		"ActionId", "actionColonyOverview",
		"ActionName", T(7849, "Colony Overview"),
		"ActionShortcut", "[",
		"ActionMode", "Game",
		"ActionBindable", true,
		"OnAction", HUD.idColonyOverviewOnPress,
		"IgnoreRepeated", true,
		"replace_matching_id", true,
	})
end

function OnMsg.ModsReloaded()
	local xt = ChoGGi.ComFuncs.RetHudButton("idRight")
	if not xt then
		return
	end

	ChoGGi.ComFuncs.RemoveXTemplateSections(xt, "ChoGGi_Template_ColonyOverview")

	table.insert(xt, #xt,
		PlaceObj("XTemplateTemplate", {
			"ChoGGi_Template_ColonyOverview", true,
			"Id", "idColonyOverview",
			"__template", "HUDButtonTemplate",
			"RolloverText", T(7850, "Aggregated information for your Colony."),
			"RolloverTitle", T(7849, "Colony Overview"),
			"Image", CurrentModPath .. "UI/statistics.png",
			"ImageShine", "UI/HUD/statistics_shine.tga",
			"FXPress", "MainMenuButtonClick",
			"OnPress", HUD.idColonyOverviewOnPress,
		})
	)

end

function HUD.idColonyOverviewOnPress()
	local dlgs = Dialogs
	-- we check for it being visible for our toggle (devs just toggled ShowResourceOverview)
	if dlgs.Infopanel and dlgs.Infopanel.XTemplate == "ipResourceOverview" then
		ShowResourceOverview = false
		CloseResourceOverviewInfopanel()
		dlgs.HUD.idColonyOverviewHighlight:SetVisible(false)
	else
		ShowResourceOverview = true
		SelectObj()
		OpenResourceOverviewInfopanel()
		dlgs.HUD.idColonyOverviewHighlight:SetVisible(true)
	end
end

-- this replaces the Sagan func with the DA one
function ReopenSelectionXInfopanel(obj, slide_in)
	local mode, template
	if obj == nil then
		obj = SelectedObj
		if (not obj and ShowResourceOverview) then
			obj = g_ResourceOverviewCity[GetMapID(obj)]
			mode = g_ResourceOverviewCity[GetMapID(obj)]:GetIPMode()
			template = "ipResourceOverview"
		end
	end
	if IsValid(obj) then
		if not slide_in then InfopanelSlideIn = false end
		local infopanel = OpenXInfopanel(nil, obj, template)
		if mode and mode ~= infopanel.Mode then
			infopanel:SetMode(mode)
		end
		return
	end
	if not GetDialog("XBuildMenu") then
		CloseXInfopanel()
	end
end

local ChoOrig_GetBasicResourcesHeading = ResourceOverview.GetBasicResourcesHeading
local ChoOrig_GetAdvancedResourcesHeading = ResourceOverview.GetAdvancedResourcesHeading
local ChoOrig_GetOtherResourcesHeading = ResourceOverview.GetOtherResourcesHeading
local function BlankText()
	return ""
end

-- removed from Sagan
function ResourceOverview:GetBasicResourcesRollover()
	local nl = T(316, "<newline>")
	local header = self:GetBasicResourcesHeading()
	ResourceOverview.GetBasicResourcesHeading = BlankText
	ResourceOverview.GetOtherResourcesHeading = BlankText

	local text = {
		T(header),
		nl,
		T(self:GetMetalsRollover()),
		nl,
		T(self:GetConcreteRollover()),
		nl,
		T(self:GetFoodRollover()),
		nl,
		T(self:GetRareMetalsRollover()),
		nl,
		T(self:GetWasteRockRollover()),
	}

	ResourceOverview.GetBasicResourcesHeading = ChoOrig_GetBasicResourcesHeading
	ResourceOverview.GetOtherResourcesHeading = ChoOrig_GetOtherResourcesHeading
	return table.concat(text, "<newline><left>")
end

function ResourceOverview:GetAdvancedResourcesRollover()
	local nl = T(316, "<newline>")
	local header = self:GetAdvancedResourcesHeading()
	ResourceOverview.GetAdvancedResourcesHeading = BlankText
	ResourceOverview.GetOtherResourcesHeading = BlankText

	local text = {
		T(header),
		nl,
		T(self:GetPolymersRollover()),
		nl,
		T(self:GetElectronicsRollover()),
		nl,
		T(self:GetMachinePartsRollover()),
		nl,
		T(self:GetFuelRollover()),
	}
	if not g_NoTerraforming then
		text[#text+1] = nl
		text[#text+1] = T(self:GetSeedsRollover())
	end

	ResourceOverview.GetAdvancedResourcesHeading = ChoOrig_GetAdvancedResourcesHeading
	ResourceOverview.GetOtherResourcesHeading = ChoOrig_GetOtherResourcesHeading
	return table.concat(text, "<newline><left>")
end
