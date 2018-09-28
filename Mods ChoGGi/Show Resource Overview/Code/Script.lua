-- add action to GameShortcuts
function OnMsg.ClassesPostprocess()
	local GameShortcuts = XTemplates.GameShortcuts
	local idx = table.find(GameShortcuts,"ActionId","actionColonyOverview")
	if idx then
		GameShortcuts[idx] = nil
	end

	GameShortcuts[#GameShortcuts+1] = PlaceObj("XTemplateAction", {
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
		Sleep(100)
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

	if IsValidThread(CurrentThread()) then
		AddHUDButton()
	else
		CreateRealTimeThread(AddHUDButton)
	end

end

function OnMsg.CityStart()
	-- CityStart is a little too early for this, so we'll wait a tad
	CreateRealTimeThread(function()
		WaitMsg("RocketLaunchFromEarth")
		StartupStuff()
	end)
end

function OnMsg.LoadGame()
  StartupStuff()
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
