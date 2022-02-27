-- See LICENSE for terms

-- add PostSaveGame to be a companion for SaveGame
local ChoOrig_ReportPersistErrors = ReportPersistErrors
function ReportPersistErrors(...)
	local errors, warnings = ChoOrig_ReportPersistErrors(...)
	-- be useful for restarting threads, see if devs will add it (yeah I think that isn't happening after two dev teams are gone)
	Msg("PostSaveGame")
	-- the assert in PersistGame() attempts to concat a nil value
	return errors, warnings
end

-- This updates my dlgs when the ui scale is changed
local pairs = pairs
local GetSafeAreaBox = GetSafeAreaBox

local ChoOrig_SetUserUIScale = SetUserUIScale
function SetUserUIScale(val, ...)
	ChoOrig_SetUserUIScale(val, ...)

	local UIScale = (val + 0.0) / 100
	-- update existing dialogs
	local ChoGGi_dlgs_opened = ChoGGi_dlgs_opened
	for dlg in pairs(ChoGGi_dlgs_opened) do
		dlg.dialog_width_scaled = dlg.dialog_width * UIScale
		dlg.dialog_height_scaled = dlg.dialog_height * UIScale
		dlg.header_scaled = dlg.header * UIScale

		-- make sure the size i use is below the res w/h
		local _, _, x, y = GetSafeAreaBox():xyxy()
		if dlg.dialog_width_scaled > x then
			dlg.dialog_width_scaled = x - 50
		end
		if dlg.dialog_height_scaled > y then
			dlg.dialog_height_scaled = y - 50
		end

		dlg:SetSize(dlg.dialog_width_scaled, dlg.dialog_height_scaled)
	end
	-- might as well update this now (used to be in an OnMsg)
	ChoGGi.Temp.UIScale = UIScale
end

-- copied from GedPropEditors.lua. it's normally only called when GED is loaded, but we need it for the colour picker (among others)
if not rawget(_G, "CreateNumberEditor") then
	local IconScale = point(500, 500)
	local IconColor = RGB(0, 0, 0)
	local RolloverBackground = RGB(204, 232, 255)
	local PressedBackground = RGB(121, 189, 241)
	local Background = RGBA(0, 0, 0, 0)
	local DisabledIconColor = RGBA(0, 0, 0, 128)
	local padding1 = box(1, 2, 1, 1)
	local padding2 = box(1, 1, 1, 2)

	function CreateNumberEditor(parent, id, up_pressed, down_pressed, skip_edit)
		local g_Classes = g_Classes

		local button_panel = g_Classes.XWindow:new({
			Dock = "right",
		}, parent)
		local top_btn = g_Classes.XTextButton:new({
			Dock = "top",
			OnPress = up_pressed,
			Padding = padding1,
			Icon = "CommonAssets/UI/arrowup-40.tga",
			IconScale = IconScale,
			IconColor = IconColor,
			DisabledIconColor = DisabledIconColor,
			Background = Background,
			DisabledBackground = Background,
			RolloverBackground = RolloverBackground,
			PressedBackground = PressedBackground,
		}, button_panel, nil, nil, "NumberArrow")
		local bottom_btn = g_Classes.XTextButton:new({
			Dock = "bottom",
			OnPress = down_pressed,
			Padding = padding2,
			Icon = "CommonAssets/UI/arrowdown-40.tga",
			IconScale = IconScale,
			IconColor = IconColor,
			DisabledIconColor = DisabledIconColor,
			Background = Background,
			DisabledBackground = Background,
			RolloverBackground = RolloverBackground,
			PressedBackground = PressedBackground,
		}, button_panel, nil, nil, "NumberArrow")
		local edit
		if not skip_edit then
			edit = g_Classes.XEdit:new({
				Id = id,
				Dock = "box",
			}, parent)

		end
		return edit, top_btn, bottom_btn
	end
end

local OpenInExamineDlg = ChoGGi.ComFuncs.OpenInExamineDlg
-- legacy (and used for console rules, so we can get around it spamming the log)
function OpenExamine(...)
	OpenInExamineDlg(...)
end
function OpenExamineRet(...)
	return OpenInExamineDlg(...)
end
-- short n sweet
ex = OpenExamine
exr = OpenExamineRet
