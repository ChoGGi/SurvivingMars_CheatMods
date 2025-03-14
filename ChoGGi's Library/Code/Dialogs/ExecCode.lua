-- See LICENSE for terms

-- Shows a dialog with to execute code in

local ChoGGi_Funcs = ChoGGi_Funcs
local T = T
local IsControlPressed = ChoGGi_Funcs.Common.IsControlPressed
local IsShiftPressed = ChoGGi_Funcs.Common.IsShiftPressed
local RetParamsParents = ChoGGi_Funcs.Common.RetParamsParents
local Translate = ChoGGi_Funcs.Common.Translate

local GetParentOfKind = ChoGGi_Funcs.Common.GetParentOfKind
local function GetRootDialog(dlg)
	return dlg.parent_dialog or GetParentOfKind(dlg, "ChoGGi_DlgExecCode")
end
DefineClass.ChoGGi_DlgExecCode = {
	__parents = {"ChoGGi_XWindow"},
	obj = false,
	obj_name = false,

	dialog_width = 850.0,
	dialog_height = 650.0,
	plugin_names = false,
	external_cmd = false,
	external_path = false,
}

local box10 = box(10, 0, 0, 0)
function ChoGGi_DlgExecCode:Init(parent, context)
	local g_Classes = g_Classes

	if ChoGGi.blacklist then
		self.plugin_names = {"ChoGGi_XCodeEditorPlugin"}
	else
		self.plugin_names = {
			"ChoGGi_XCodeEditorPlugin",
			"ChoGGi_XExternalTextEditorPlugin",
		}
	end

	self.obj = context.obj
	self.obj_name = self.obj and ChoGGi_Funcs.Common.RetName(self.obj) or T(302535920001073--[[Console]])

	self.title = T(302535920000040--[[Exec Code]]) .. ": " .. self.obj_name

	if not self.obj then
		self.dialog_width = 800.0
		self.dialog_height = 650.0
	end

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self:AddScrollEdit()

	-- hinty hint
	self.idMoveControl.RolloverText = T(302535920000072--[["Paste or type code to be executed here, o is the examined object (ignored when opened from Console).
Press Ctrl-Enter or Shift-Enter to execute code."]])
	-- start off with this as code
	self.idEdit:SetText(GetFromClipboard() or self.obj and "o" or "")
	-- let us override enter/esc
	self.idEdit.OnKbdKeyDown = self.idEdit_OnKbdKeyDown
	-- update text on focus
	self.idEdit.OnSetFocus = self.idEdit_OnSetFocus

	self.idEdit:SetPlugins(self.plugin_names)
--~ 	self.idEdit.update_thread = self.idEdit:CreateThread("update_thread", self.idEdit.UpdateThread, self.idEdit)

	self.idButtonContainer = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idButtonContainer",
		Dock = "bottom",
		Margins = box(0, 0, 0, 4),
	}, self.idDialog)

	-- top row
	if not ChoGGi.blacklist then
		self.idTopButs = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idTopButs",
			Dock = "top",
			Margins = box(0, 0, 0, 4),
		}, self.idButtonContainer)

		self.idEdit.external_cmd = ChoGGi.UserSettings.ExternalEditorCmd
		self.idEdit.external_path = ChoGGi.UserSettings.ExternalEditorPath

		self.idExterEdit = g_Classes.ChoGGi_XButton:new({
			Id = "idExterEdit",
			Dock = "left",
			Text = T(302535920000471--[[External Editor]]),
			RolloverText = T(302535920001434--[["Use an external editor (see settings for editor cmd).
Updates external file when you type in editor (only updates text when you press Read File).
Press again to toggle updating."]]),
			Margins = box10,
			OnPress = self.idExterEdit_OnPress,
		}, self.idTopButs)

		self.idExterReadFile = g_Classes.ChoGGi_XButton:new({
			Id = "idExterReadFile",
			Dock = "left",
			Text = T(302535920001435--[[Read File]]),
			RolloverText = T{302535920001436--[["Update editor text with text from <color ChoGGi_green><path>tempedit.lua</color>."]],
				path = self.idEdit.external_path,
			},
			Margins = box10,
			OnPress = self.idExterReadFile_OnPress,
			FoldWhenHidden = true,
		}, self.idTopButs)
		self.idExterReadFile:SetVisible(false)

		self.idExterFocusUpdate = g_Classes.ChoGGi_XCheckButton:new({
			Id = "idExterFocusUpdate",
			Dock = "left",
			Text = T(302535920001438--[[Focus Update]]),
			RolloverText = T(302535920001437--[[Reads file when you focus on the edit box (instead of pressing Read File).]]),
			Margins = box10,
			OnChange = self.idExterFocusUpdate_OnChange,
			FoldWhenHidden = true,
		}, self.idTopButs)
		self.idExterFocusUpdate:SetVisible(false)
	end -- top row

	self.idBottomButs = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idBottomButs",
		Dock = "bottom",
	}, self.idButtonContainer)

	do -- left side

		self.idLeftButs = g_Classes.ChoGGi_XDialogSection:new({
			Id = "idLeftButs",
			Dock = "left",
		}, self.idBottomButs)

		self.idOK = g_Classes.ChoGGi_XButton:new({
			Id = "idOK",
			Dock = "left",
			Background = g_Classes.ChoGGi_XButton.bg_green,
			Text = T(302535920000040--[[Exec Code]]),
			RolloverText = T(302535920000073--[[Execute code in text box (Ctrl-Enter or Shift-Enter will also work).]]),
			Margins = box10,
			OnPress = self.idOK_OnPress,
		}, self.idLeftButs)

		if self.obj then
			self.idInsertObj = g_Classes.ChoGGi_XButton:new({
				Id = "idInsertObj",
				Dock = "left",
				Text = T(302535920000075--[[Insert Obj]]),
				RolloverText = T(302535920000076--[[At caret position inserts: o]]),
				Margins = box10,
				OnPress = self.idInsertObj_OnPress,
			}, self.idLeftButs)
		end
	end -- left side

	do -- right side
	self.idRightButs = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idRightButs",
		Dock = "right",
	}, self.idBottomButs)

	self.idToggleCode = g_Classes.ChoGGi_XCheckButton:new({
		Id = "idToggleCode",
		Dock = "left",
		Text = T(302535920001474--[[Code Highlight]]),
		RolloverText = T(302535920001475--[[Toggle lua code highlighting.]]),
		OnChange = self.idToggleCode_OnChange,
	}, self.idRightButs)
	self.idToggleCode:SetCheckBox(true)

	self.idWrapLines = g_Classes.ChoGGi_XCheckButton:new({
		Id = "idWrapLines",
		Dock = "left",
		Text = T(302535920001288--[[Wrap Lines]]),
		RolloverText = T(302535920001289--[[Wrap lines or show horizontal scrollbar.]]),
		Margins = box10,
		OnChange = self.idWrapLines_OnChange,
	}, self.idRightButs)
	self.idWrapLines:SetCheckBox(ChoGGi.UserSettings.WordWrap and true or false)

	self.idCancel = g_Classes.ChoGGi_XButton:new({
		Id = "idCancel",
		Dock = "right",
		Text = T(302535920001713--[[Cancel]]),
		Background = g_Classes.ChoGGi_XButton.bg_red,
		RolloverText = T(302535920000074--[[Cancel without changing anything.]]),
		Margins = box(0, 0, 10, 0),
		OnPress = self.idCloseX.OnPress,
	}, self.idRightButs)

	end -- right side

	self:PostInit(context.parent)
end

-- toggle code highlighting
function ChoGGi_DlgExecCode:idToggleCode_OnChange(check)
	self = GetRootDialog(self)
	if check then
		self.idEdit:SetPlugins(self.plugin_names)
	else
		self.idEdit:RemovePlugin("ChoGGi_XCodeEditorPlugin")
	end
end

function ChoGGi_DlgExecCode:idEdit_OnSetFocus(...)
	if self.focus_update and self == g_ExternalTextEditorActiveCtrl then
		g_Classes.ChoGGi_XExternalTextEditorPlugin.ApplyEdit(nil, "Modified", self)
	end
	return g_Classes.ChoGGi_XMultiLineEdit.OnSetFocus(self, ...)
end

function ChoGGi_DlgExecCode:idExterFocusUpdate_OnChange(which)
	GetRootDialog(self).idEdit.focus_update = which
end

function ChoGGi_DlgExecCode:idExterReadFile_OnPress()
	g_Classes.ChoGGi_XExternalTextEditorPlugin.ApplyEdit(nil, "Modified", GetRootDialog(self).idEdit)
end

function ChoGGi_DlgExecCode:idExterEdit_OnPress()
	self = GetRootDialog(self)
	-- stop updating
	if self.idEdit == g_ExternalTextEditorActiveCtrl then
		g_ExternalTextEditorActiveCtrl = false
		self.idExterReadFile:SetVisible(false)
		self.idExterFocusUpdate:SetVisible(false)
		return
	end

	-- add updater
	local idx = table.find(self.idEdit.plugins, "class", "ChoGGi_XExternalTextEditorPlugin")
	if idx then
		self.idExterReadFile:SetVisible(true)
		self.idExterFocusUpdate:SetVisible(true)
		self.idEdit.plugins[idx]:OpenEditor(self.idEdit)
	end
end

function ChoGGi_DlgExecCode:idOK_OnPress()
	self = GetRootDialog(self)
	-- exec instead of also closing dialog
	o = self.obj
	-- use console to exec code so we can show results in it
	dlgConsole:Exec(self.idEdit:GetText())
end

function ChoGGi_DlgExecCode:idInsertObj_OnPress()
	self = GetRootDialog(self)
	self.idEdit:EditOperation("o", true)
	self.idEdit:SetFocus()
end

function ChoGGi_DlgExecCode:idWrapLines_OnChange(which)
	ChoGGi.UserSettings.WordWrap = which
	GetRootDialog(self).idEdit:SetWordWrap(which)
end

local const = const
function ChoGGi_DlgExecCode:idEdit_OnKbdKeyDown(vk)
	self = GetRootDialog(self)
	if vk == const.vkEnter and (IsShiftPressed() or IsControlPressed()) then
		self.idOK:Press()
		return "break"
	elseif vk == const.vkEsc and self.obj then
		self.idCloseX:Press()
		return "break"
	end
	return g_Classes.ChoGGi_XTextInput.OnKbdKeyDown(self.idEdit, vk)
end

function ChoGGi_DlgExecCode:CloseXButtonFunc()
	-- kill off exter editor if active
	local ext = g_ExternalTextEditorActiveCtrl
	if ext and ext.delete then
		ext:delete()
		g_ExternalTextEditorActiveCtrl = false
	end
end

function ChoGGi_DlgExecCode:Done()
	-- kill off external editor stuff?
	if self.idEdit == g_ExternalTextEditorActiveCtrl then
		g_ExternalTextEditorActiveCtrl = false
	end
end

-- Use to open a dialog
function ChoGGi_Funcs.Common.OpenInExecCodeDlg(obj, parent, ...)
	local params, parent_type
	params, parent, parent_type = RetParamsParents(parent, params, ...)

	if not IsKindOf(parent, "XWindow") then
		parent = nil
	end

	params.obj = obj
	params.parent = parent

	return ChoGGi_DlgExecCode:new({}, terminal.desktop, params)
end

