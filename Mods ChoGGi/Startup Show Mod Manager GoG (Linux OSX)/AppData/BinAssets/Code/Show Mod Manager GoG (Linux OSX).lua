-- See LICENSE for terms

local function AddButton(buttons,id,title,menu,func)
	buttons[id] = XWindow:new({
		Id = id,
		ZOrder = 0,
	}, buttons)
	XTextButton:new({
		Text = title,
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
		OnPress = func,
	}, buttons[id])
end

local table_find = table.find
local function SetModNew(menu)
	local buttons = menu.idContent and menu.idContent.idBottomButtons
	local idx
	if buttons then
		idx = table_find(buttons,"class","XWindow")
	end

	if idx then
		buttons = buttons[idx]

		AddButton(buttons,"idModManager",T(1129, "MOD MANAGER"),menu,function()
			menu:SetMode("ModManager")
		end)

		AddButton(buttons,"idModEditor",T(1130, "MOD EDITOR"),nil,function()
			CreateRealTimeThread(ModEditorOpen)
		end)

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

		-- needs to fire once for main menu
		SetModNew(Dialogs.PGMainMenu)

		-- if users goes into options or something than we fire it again at main menu
		local orig_SetMode = Dialogs.PGMainMenu.SetMode
		function Dialogs.PGMainMenu:SetMode(mode,...)
			orig_SetMode(self,mode,...)
			if mode == "" then
				SetModNew(self)
			end
		end

	end)

end