local Sleep = Sleep
local table_find = table.find

local function SetModNew(menu)
	local buttons = menu.idContent and menu.idContent.idBottomButtons
	local idx = table_find(buttons,"class","XWindow")

	if idx then
		buttons = buttons[idx]
		buttons.idModManager = XWindow:new({
			Id = "idModManager",
			ZOrder = 0,
		}, buttons)

		XTextButton:new({
			Text = T(1129, --[[XTemplate PGMenuNew ActionName]] "MOD MANAGER"),
			Background = 16777215,
			DisabledBackground = 7895160,
			FocusedBackground = 16777215,
			FXMouseIn = "MainMenuItemHover",
			FXPress = "MainMenuItemClick",
			FXPressDisabled = "UIDisabledButtonPressed",
			MouseCursor = "UI/Cursors/Rollover.tga",
			PressedBackground = 16777215,
			RolloverAnchor = "center-top",
			RolloverBackground = 16777215,
			RolloverTemplate = "Rollover",
			TextStyle = "Action",
			Translate = true,
			VAlign = "center",
			OnPress = function()
				menu:SetMode("ModManager")
			end,
		}, buttons.idModManager)

	end
end

function OnMsg.DesktopCreated()

  CreateRealTimeThread(function()
		local WaitMsg = WaitMsg
		local Dialogs = Dialogs

		WaitMsg("OnRender")
		while not Dialogs.PGMainMenu do
			WaitMsg("OnRender")
		end

		local orig_SetMode = Dialogs.PGMainMenu.SetMode
		Dialogs.PGMainMenu.SetMode = function(self,...)
			orig_SetMode(self,...)
			SetModNew(self)
		end

		-- needs to fire once here
		SetModNew(Dialogs.PGMainMenu)

	end)

end