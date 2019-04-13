-- See LICENSE for terms

local T = T

local TableConcat = ChoGGi.ComFuncs.TableConcat

-- add action to GameShortcuts
function OnMsg.ClassesPostprocess()
	-- if action exists then replace it, otherwise add to the end
	local GameShortcuts = XTemplates.GameShortcuts
	local idx = table.find(GameShortcuts,"ActionId","actionColonyOverview")
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

	ChoGGi.ComFuncs.RemoveXTemplateSections(xt,"ChoGGi_Template_ColonyOverview")

	table.insert(xt,#xt,
		PlaceObj("XTemplateTemplate", {
			"ChoGGi_Template_ColonyOverview", true,
			"__template", "HUDButtonTemplate",
			"RolloverText", T(7850, "Aggregated information for your Colony."),
			"RolloverTitle", T(7849, "Colony Overview"),
			"Id", "idColonyOverview",
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
			obj = ResourceOverviewObj
			mode = ResourceOverviewObj:GetIPMode()
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

-- removed from Sagan
function ResourceOverview:GetBasicResourcesRollover()
	local ret = {
			T(3635, "Basic resource production, consumption and other stats from the <em>last Sol</em>, unless otherwise stated. Resources in consumption buildings are not counted towards the total available amount. Resource maintenance is estimated per Sol."),
			T(316, "<newline>"),
			T(3636, "Metals production<right><metals(MetalsProducedYesterday)>", self),
			T(3637, "From surface deposits<right><metals(MetalsGatheredYesterday)>", self),
			T(3638, "Metals consumption<right><metals(MetalsConsumedByConsumptionYesterday)>", self),
			T(3639, "Metals maintenance<right><metals(MetalsConsumedByMaintenanceYesterday)>", self),
			T(10081, "In construction sites<right><metals(MetalsInConstructionSitesActual, MetalsInConstructionSitesTotal)>", self),
			T(10526, "Upgrade construction<right><metals(MetalsUpgradeConstructionActual, MetalsUpgradeConstructionTotal)>", self),
			T(316, "<newline>"),
			T(3640, "Concrete production<right><concrete(ConcreteProducedYesterday)>", self),
			T(3641, "Concrete consumption<right><concrete(ConcreteConsumedByConsumptionYesterday)>", self),
			T(3642, "Concrete maintenance<right><concrete(ConcreteConsumedByMaintenanceYesterday)>", self),
			T(10082, "In construction sites<right><concrete(ConcreteInConstructionSitesActual, ConcreteInConstructionSitesTotal)>", self),
			T(10527, "Upgrade construction<right><concrete(ConcreteUpgradeConstructionActual, ConcreteUpgradeConstructionTotal)>", self),
			T(316, "<newline>"),
			T(3643, "Food production<right><food(FoodProducedYesterday)>", self),
			T(3644, "Food consumption<right><food(FoodConsumedByConsumptionYesterday)>", self),
			T(9767, "Stored in service buildings<right><food(FoodStoredInServiceBuildings)>", self),
			T(316, "<newline>"),
			T(3646, "Rare Metals production<right><preciousmetals(PreciousMetalsProducedYesterday)>", self),
			T(3647, "Rare Metals consumption<right><preciousmetals(PreciousMetalsConsumedByConsumptionYesterday)>", self),
			T(3648, "Rare Metals maintenance<right><preciousmetals(PreciousMetalsConsumedByMaintenanceYesterday)>", self),
			T(10528, "Upgrade construction<right><preciousmetals(PreciousMetalsUpgradeConstructionActual, PreciousMetalsUpgradeConstructionTotal)>", self),
			T(3649, "<LastExportStr>", self),
		}
	return TableConcat(ret, "<newline><left>")
end

function ResourceOverview:GetAdvancedResourcesRollover()
	local ret = {
			T(3654, "Advanced resource production, consumption and other stats from the <em>last Sol</em>, unless otherwise stated. Resources in consumption buildings are not counted towards the total available amount. Resource maintenance is estimated per Sol."},
			T(316, "<newline>"),
			T(3655, "Polymers production<right><polymers(PolymersProducedYesterday)>", self),
			T(3656, "From surface deposits<right><polymers(PolymersGatheredYesterday)>", self),
			T(3657, "Polymers consumption<right><polymers(PolymersConsumedByConsumptionYesterday)>", self),
			T(3658, "Polymers maintenance<right><polymers(PolymersConsumedByMaintenanceYesterday)>", self),
			T(10083, "In construction sites<right><polymers(PolymersInConstructionSitesActual, PolymersInConstructionSitesTotal)>", self),
			T(10529, "Upgrade construction<right><polymers(PolymersUpgradeConstructionActual, PolymersUpgradeConstructionTotal)>", self),
			T(316, "<newline>"),
			T(3659, "Electronics production<right><electronics(ElectronicsProducedYesterday)>", self),
			T(3660, "Electronics consumption<right><electronics(ElectronicsConsumedByConsumptionYesterday)>", self),
			T(3661, "Electronics maintenance<right><electronics(ElectronicsConsumedByMaintenanceYesterday)>", self),
			T(10084, "In construction sites<right><electronics(ElectronicsInConstructionSitesActual, ElectronicsInConstructionSitesTotal)>", self),
			T(10530, "Upgrade construction<right><electronics(ElectronicsUpgradeConstructionActual, ElectronicsUpgradeConstructionTotal)>", self),
			T(316, "<newline>"),
			T(3662, "Machine Parts production<right><machineparts(MachinePartsProducedYesterday)>", self),
			T(3663, "Machine Parts consumption<right><machineparts(MachinePartsConsumedByConsumptionYesterday)>", self),
			T(3664, "Machine Parts maintenance<right><machineparts(MachinePartsConsumedByMaintenanceYesterday)>", self),
			T(10085, "In construction sites<right><machineparts(MachinePartsInConstructionSitesActual, MachinePartsInConstructionSitesTotal)>", self),
			T(10531, "Upgrade construction<right><machineparts(MachinePartsUpgradeConstructionActual, MachinePartsUpgradeConstructionTotal)>", self),
			T(316, "<newline>"),
			T(3665, "Fuel production<right><fuel(FuelProducedYesterday)>", self),
			T(3666, "Fuel consumption<right><fuel(FuelConsumedByConsumptionYesterday)>", self),
			T(3667, "Fuel maintenance<right><fuel(FuelConsumedByMaintenanceYesterday)>", self),
			T(3668, "Refueling of Rockets<right><fuel(RocketRefuelFuelYesterday)>", self),
			T(316, "<newline>"),
		}
	return TableConcat(ret, "<newline><left>")
end
