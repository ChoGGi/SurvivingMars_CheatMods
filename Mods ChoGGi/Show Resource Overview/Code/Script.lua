-- add action to GameShortcuts
function OnMsg.ClassesPostprocess()

	-- if out of some miracle it's here, remove it so it doesn't interfere
	local GameShortcuts = XTemplates.GameShortcuts
	local idx = table.find(GameShortcuts,"ActionId","actionColonyOverview")
--~ 	if idx then
--~ 		GameShortcuts[idx] = nil
--~ 	end

	-- add the actual shortcut
	GameShortcuts[idx or #GameShortcuts+1] = PlaceObj("XTemplateAction", {
		"ActionId", "actionColonyOverview",
		"ActionName", T{7849, "Colony Overview"},
		"ActionShortcut", "O",
		"ActionMode", "Game",
		"ActionBindable", true,
		"OnAction", function()
			local igi = GetInGameInterface()
			local dlg = Dialogs and Dialogs.HUD
			if igi and dlg and dlg.window_state ~= "destroying" and igi:GetVisible() then
				dlg.idColonyOverview:Press()
			end
		end,
		"IgnoreRepeated", true,
		"replace_matching_id", true,
	})
end

-- this adds the actual button, and makes it work
local function AddHUDButton()
	-- wait for hud to be created so we can fiddle with it
	local Dialogs = Dialogs
	local Sleep = Sleep
	while not Dialogs.HUD do
		Sleep(500)
	end
	-- if it's already been added somehow
	if Dialogs.HUD.idColonyOverview then
		return
	end

	-- button object
	local win = XWindow:new({}, Dialogs.HUD.idRightButtons)
	local button = HUD.button_definitions.idColonyOverview
	HUDButton:new({
		Id = "idColonyOverview",
		Image = button.image,
		Rows = button.Rows or 1,
		FXPress = button.FXPress,
	}, win)
	XImage:new({
		HandleMouse = false,
		Id = "idColonyOverviewHighlight",
		Image = button.shine,
	}, win)
	-- only vis when mouseover/enabled?
	Dialogs.HUD.idColonyOverviewHighlight:SetVisible(false)

	-- needed for the button to actally do anything
	Dialogs.HUD:InitControls()
	-- probably not needed
	Dialogs.HUD:UpdateHUDButtons()
end

local function StartupStuff()
	local HUD = HUD

	RightHUDButtons = {"idColonyControlCenter", "idColonyOverview", "idMarkers", "idRadio", "idMenu"}

	HUD.button_definitions.idColonyOverview = {
		rollover = {
			id = "Resource Overview",
			title = T{7849, "Colony Overview"},
			descr = T{7850, "Aggregated information for your Colony."},
			hint = T{7851, "<em><ShortcutName('actionColonyOverview')></em> - toggle Colony Overview"},
		},
		selection = true,
		callback = function(this)
			local Dialogs = Dialogs
			-- we check for it being visble for our toggle (devs just toggled ShowResourceOverview)
			if Dialogs.Infopanel and Dialogs.Infopanel.XTemplate == "ipResourceOverview" then
				ShowResourceOverview = false
				CloseResourceOverviewInfopanel()
			else
				ShowResourceOverview = true
				SelectObj()
				OpenResourceOverviewInfopanel()
			end
			this:SetToggled(ShowResourceOverview)
		end,
		image = "UI/HUD/statistics.tga",
		shine = "UI/HUD/statistics_shine.tga",
		Rows = 2,
		FXPress = "ResourceOverviewButtonClick",
	}
	HUD.button_list = table.keys2(HUD.button_definitions, true)

	AddHUDButton()
end

function OnMsg.CityStart()
	-- CityStart is a little too early for this, so we'll wait a tad
	CreateRealTimeThread(function()
		WaitMsg("RocketLaunchFromEarth")
		StartupStuff()
	end)
end

function OnMsg.LoadGame()
	-- thread could be needed by AddHUDButton
	CreateRealTimeThread(function()
		StartupStuff()
	end)
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
			T{3635, "Basic resource production, consumption and other stats from the <em>last Sol</em>, unless otherwise stated. Resources in consumption buildings are not counted towards the total available amount. Resource maintenance is estimated per Sol."},
			T{316, "<newline>"},
			T{3636, "Metals production<right><metals(MetalsProducedYesterday)>", self},
			T{3637, "From surface deposits<right><metals(MetalsGatheredYesterday)>", self},
			T{3638, "Metals consumption<right><metals(MetalsConsumedByConsumptionYesterday)>", self},
			T{3639, "Metals maintenance<right><metals(MetalsConsumedByMaintenanceYesterday)>", self},
			T{10081, "In construction sites<right><metals(MetalsInConstructionSitesActual, MetalsInConstructionSitesTotal)>", self},
			T{10526, "Upgrade construction<right><metals(MetalsUpgradeConstructionActual, MetalsUpgradeConstructionTotal)>", self},
			T{316, "<newline>"},
			T{3640, "Concrete production<right><concrete(ConcreteProducedYesterday)>", self},
			T{3641, "Concrete consumption<right><concrete(ConcreteConsumedByConsumptionYesterday)>", self},
			T{3642, "Concrete maintenance<right><concrete(ConcreteConsumedByMaintenanceYesterday)>", self},
			T{10082, "In construction sites<right><concrete(ConcreteInConstructionSitesActual, ConcreteInConstructionSitesTotal)>", self},
			T{10527, "Upgrade construction<right><concrete(ConcreteUpgradeConstructionActual, ConcreteUpgradeConstructionTotal)>", self},
			T{316, "<newline>"},
			T{3643, "Food production<right><food(FoodProducedYesterday)>", self},
			T{3644, "Food consumption<right><food(FoodConsumedByConsumptionYesterday)>", self},
			T{9767, "Stored in service buildings<right><food(FoodStoredInServiceBuildings)>", self},
			T{316, "<newline>"},
			T{3646, "Rare Metals production<right><preciousmetals(PreciousMetalsProducedYesterday)>", self},
			T{3647, "Rare Metals consumption<right><preciousmetals(PreciousMetalsConsumedByConsumptionYesterday)>", self},
			T{3648, "Rare Metals maintenance<right><preciousmetals(PreciousMetalsConsumedByMaintenanceYesterday)>", self},
			T{10528, "Upgrade construction<right><preciousmetals(PreciousMetalsUpgradeConstructionActual, PreciousMetalsUpgradeConstructionTotal)>", self},
			T{3649, "<LastExportStr>", self},
		}
	return table.concat(ret, "<newline><left>")
end

function ResourceOverview:GetAdvancedResourcesRollover()
	local ret = {
			T{3654, "Advanced resource production, consumption and other stats from the <em>last Sol</em>, unless otherwise stated. Resources in consumption buildings are not counted towards the total available amount. Resource maintenance is estimated per Sol."},
			T{316, "<newline>"},
			T{3655, "Polymers production<right><polymers(PolymersProducedYesterday)>", self},
			T{3656, "From surface deposits<right><polymers(PolymersGatheredYesterday)>", self},
			T{3657, "Polymers consumption<right><polymers(PolymersConsumedByConsumptionYesterday)>", self},
			T{3658, "Polymers maintenance<right><polymers(PolymersConsumedByMaintenanceYesterday)>", self},
			T{10083, "In construction sites<right><polymers(PolymersInConstructionSitesActual, PolymersInConstructionSitesTotal)>", self},
			T{10529, "Upgrade construction<right><polymers(PolymersUpgradeConstructionActual, PolymersUpgradeConstructionTotal)>", self},
			T{316, "<newline>"},
			T{3659, "Electronics production<right><electronics(ElectronicsProducedYesterday)>", self},
			T{3660, "Electronics consumption<right><electronics(ElectronicsConsumedByConsumptionYesterday)>", self},
			T{3661, "Electronics maintenance<right><electronics(ElectronicsConsumedByMaintenanceYesterday)>", self},
			T{10084, "In construction sites<right><electronics(ElectronicsInConstructionSitesActual, ElectronicsInConstructionSitesTotal)>", self},
			T{10530, "Upgrade construction<right><electronics(ElectronicsUpgradeConstructionActual, ElectronicsUpgradeConstructionTotal)>", self},
			T{316, "<newline>"},
			T{3662, "Machine Parts production<right><machineparts(MachinePartsProducedYesterday)>", self},
			T{3663, "Machine Parts consumption<right><machineparts(MachinePartsConsumedByConsumptionYesterday)>", self},
			T{3664, "Machine Parts maintenance<right><machineparts(MachinePartsConsumedByMaintenanceYesterday)>", self},
			T{10085, "In construction sites<right><machineparts(MachinePartsInConstructionSitesActual, MachinePartsInConstructionSitesTotal)>", self},
			T{10531, "Upgrade construction<right><machineparts(MachinePartsUpgradeConstructionActual, MachinePartsUpgradeConstructionTotal)>", self},
			T{316, "<newline>"},
			T{3665, "Fuel production<right><fuel(FuelProducedYesterday)>", self},
			T{3666, "Fuel consumption<right><fuel(FuelConsumedByConsumptionYesterday)>", self},
			T{3667, "Fuel maintenance<right><fuel(FuelConsumedByMaintenanceYesterday)>", self},
			T{3668, "Refueling of Rockets<right><fuel(RocketRefuelFuelYesterday)>", self},
			T{316, "<newline>"},
		}
	return table.concat(ret, "<newline><left>")
end
