-- See LICENSE for terms

-- shows a dialog with to execute code in

local StringFormat = string.format

local S
local GetParentOfKind
local IsControlPressed
local IsShiftPressed

function OnMsg.ClassesGenerate()
	S = ChoGGi.Strings
	GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
	IsControlPressed = ChoGGi.ComFuncs.IsControlPressed
	IsShiftPressed = ChoGGi.ComFuncs.IsShiftPressed
end

local GetRootDialog = function(obj)
	return GetParentOfKind(obj,"ChoGGi_ExecCodeDlg")
end
DefineClass.ChoGGi_ExecCodeDlg = {
	__parents = {"ChoGGi_Window"},
	obj = false,
	obj_name = false,

	dialog_width = 700.0,
	dialog_height = 240.0,
}

local box10 = box(10,0,0,0)
function ChoGGi_ExecCodeDlg:Init(parent, context)
	local ChoGGi = ChoGGi
	local g_Classes = g_Classes
	local dlgConsole = dlgConsole

	self.obj = context.obj
	self.obj_name = self.obj and ChoGGi.ComFuncs.RetName(self.obj) or S[302535920001073--[[Console--]]]

	self.title = StringFormat("%s: %s",S[302535920000040--[[Exec Code--]]],self.obj_name)

	if not self.obj then
		self.dialog_width = 800.0
		self.dialog_height = 650.0
	end

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self:AddScrollEdit()

	-- hinty hint
	self.idMoveControl.RolloverText = S[302535920000072--[["Paste or type code to be executed here, ChoGGi.CurObj is the examined object (ignored when opened from Console).
Press Ctrl-Enter or Shift-Enter to execute code."--]]]
	-- start off with this as code
	self.idEdit:SetText(GetFromClipboard() or self.obj and "ChoGGi.CurObj" or "")
	-- let us override enter/esc
	self.idEdit.OnKbdKeyDown = self.idEditOnKbdKeyDown

	self.idButtonContainer = g_Classes.ChoGGi_DialogSection:new({
		Id = "idButtonContainer",
		Dock = "bottom",
		Margins = box(0,0,0,4),
	}, self.idDialog)

	self.idOK = g_Classes.ChoGGi_Button:new({
		Id = "idOK",
		Dock = "left",
		Text = S[302535920000040--[[Exec Code--]]],
		RolloverText = S[302535920000073--[[Execute code in text box (Ctrl-Enter or Shift-Enter will also work).--]]],
		Margins = box10,
		MinWidth = 100,
		OnPress = self.idOKOnPress,
	}, self.idButtonContainer)

	if self.obj then
		self.idInsertObj = g_Classes.ChoGGi_Button:new({
			Id = "idInsertObj",
			Dock = "left",
			Text = S[302535920000075--[[Insert Obj--]]],
			RolloverText = S[302535920000076--[[At caret position inserts: ChoGGi.CurObj--]]],
			Margins = box10,
			MinWidth = 100,
			OnPress = self.idInsertObjOnPress,
		}, self.idButtonContainer)
	end

	self.idWrapLines = g_Classes.ChoGGi_CheckButton:new({
		Id = "idWrapLines",
		Dock = "left",
		Text = S[302535920001288--[[Wrap Lines--]]],
		RolloverText = S[302535920001289--[[Wrap lines or show horizontal scrollbar.--]]],
		Margins = box10,
		Check = ChoGGi.UserSettings.WordWrap,
		OnChange = self.idWrapLinesOnChange,
	}, self.idButtonContainer)

	self.idCancel = g_Classes.ChoGGi_Button:new({
		Id = "idCancel",
		Dock = "right",
		MinWidth = 80,
		Text = S[6879--[[Cancel--]]],
		RolloverText = S[302535920000074--[[Cancel without changing anything.--]]],
		Margins = box(0, 0, 10, 0),
		OnPress = self.idCloseX.OnPress,
	}, self.idButtonContainer)

	self:SetInitPos(context.parent)
end

function ChoGGi_ExecCodeDlg:idOKOnPress()
	self = GetRootDialog(self)
	-- exec instead of also closing dialog
	ChoGGi.CurObj = self.obj
--~ 	ShowConsoleLog(true)
	-- use console to exec code so we can show results in it
	dlgConsole:Exec(self.idEdit:GetText())
end

function ChoGGi_ExecCodeDlg:idInsertObjOnPress()
	self = GetRootDialog(self)
	self.idEdit:EditOperation("ChoGGi.CurObj",true)
	self.idEdit:SetFocus()
end

function ChoGGi_ExecCodeDlg:idWrapLinesOnChange(which)
	ChoGGi.UserSettings.WordWrap = which
	GetRootDialog(self).idEdit:SetWordWrap(which)
end

local const = const
function ChoGGi_ExecCodeDlg:idEditOnKbdKeyDown(vk)
	self = GetRootDialog(self)
	if vk == const.vkEnter and (IsShiftPressed() or IsControlPressed()) then
		self.idOK:Press()
--~ 		if IsShiftPressed() or IsControlPressed() then
--~ 			self.idOK:Press()
--~ 		end
		return "break"
	elseif vk == const.vkEsc and self.obj then
		self.idCloseX:Press()
		return "break"
	end
	return ChoGGi_TextInput.OnKbdKeyDown(self.idEdit, vk)
end
