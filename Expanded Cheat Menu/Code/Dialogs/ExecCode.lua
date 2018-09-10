-- See LICENSE for terms

-- shows a dialog with to execute code in

function OnMsg.ClassesGenerate()

	local S = ChoGGi.Strings

	DefineClass.ChoGGi_ExecCodeDlg = {
		__parents = {"ChoGGi_Window"},
		obj = false,
		obj_name = false,

		dialog_width = 700.0,
		dialog_height = 240.0,
	}

	function ChoGGi_ExecCodeDlg:Init(parent, context)
		local ChoGGi = ChoGGi
		local g_Classes = g_Classes
		local dlgConsole = dlgConsole

		self.obj = context.obj
		self.obj_name = self.obj and ChoGGi.ComFuncs.RetName(self.obj) or S[302535920001073--[[Console--]]]

		self.title = string.format("%s: %s",S[302535920000040--[[Exec Code--]]],self.obj_name)

		if not self.obj then
			self.dialog_width = 800.0
			self.dialog_height = 650.0
		end

		-- By the Power of Grayskull!
		self:AddElements(parent, context)

		self:AddScrollEdit()

		-- start off with this as code
		self.idEdit:SetText(GetFromClipboard() or (self.obj and "ChoGGi.CurObj" or ""))
		-- focus on text
		self.idEdit:SetFocus()
		-- hinty hint
		self.idEdit:SetRolloverText(S[302535920000072--[["Paste or type code to be executed here, ChoGGi.CurObj is the examined object (ignored when opened from Console).
	Press Ctrl-Enter or Shift-Enter to execute code."--]]])
		-- let us override enter/esc
		self.idEdit.OnKbdKeyDown = function(obj, vk)
			return self:idEditOnKbdKeyDown(obj, vk)
		end

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
			Margins = box(10, 0, 0, 0),
			MinWidth = 100,
			OnPress = function()
				-- exec instead of also closing dialog
				ChoGGi.CurObj = self.obj
				-- use console to exec code so we can show results in it
				ShowConsoleLog(true)
				dlgConsole:Exec(self.idEdit:GetText())
			end,
		}, self.idButtonContainer)

		if self.obj then
			self.idInsertObj = g_Classes.ChoGGi_Button:new({
				Id = "idInsertObj",
				Dock = "left",
				Text = S[302535920000075--[[Insert Obj--]]],
				RolloverText = S[302535920000076--[[At caret position inserts: ChoGGi.CurObj--]]],
				Margins = box(10, 0, 0, 0),
				MinWidth = 100,
				OnPress = function()
					self.idEdit:EditOperation("ChoGGi.CurObj",true)
					self.idEdit:SetFocus()
				end,
			}, self.idButtonContainer)
		end

		g_Classes.ChoGGi_CheckButton:new({
			Dock = "left",
			Text = S[302535920001288--[[Wrap Lines--]]],
			RolloverText = S[302535920001289--[[Wrap lines or show horizontal scrollbar.--]]],
			Margins = box(10,0,0,0),
			Check = ChoGGi.UserSettings.WordWrap,
			OnChange = function(_,which)
				ChoGGi.UserSettings.WordWrap = which
				self.idEdit:SetWordWrap(which)
			end
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

	local IsKeyPressed = terminal.IsKeyPressed
	local shift_key = const.vkShift
	local ctrl_key = Platform.osx and const.vkLwin or const.vkControl
	function ChoGGi_ExecCodeDlg:idEditOnKbdKeyDown(obj,vk)
		local const = const
		if vk == const.vkEnter then
			if IsKeyPressed(shift_key) or IsKeyPressed(ctrl_key) then
				self.idOK:Press()
			end
			return "break"
		elseif vk == const.vkEsc and self.obj then
			self.idCloseX:Press()
			return "break"
		end
		return ChoGGi_TextInput.OnKbdKeyDown(obj, vk)
	end

end
