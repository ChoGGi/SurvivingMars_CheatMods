-- See LICENSE for terms

-- displays the log in a dialog

local S
local blacklist
local GetParentOfKind

local StringFormat = string.format

function OnMsg.ClassesGenerate()
	S = ChoGGi.Strings
	blacklist = ChoGGi.blacklist
	GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
end

local function GetRootDialog(dlg)
	return GetParentOfKind(dlg,"ChoGGi_ConsoleLogWin")
end
DefineClass.ChoGGi_ConsoleLogWin = {
	__parents = {"ChoGGi_Window"},
	transp_mode = false,
	update_thread = false,

	dialog_width = 700.0,
	dialog_height = 500.0,
	title = 302535920001120--[[Console Log Window--]],
}

function ChoGGi_ConsoleLogWin:Init(parent, context)
	local ChoGGi = ChoGGi
	local g_Classes = g_Classes

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.idButtonContainer = g_Classes.ChoGGi_DialogSection:new({
		Id = "idButtonContainer",
		Dock = "top",
	}, self.idDialog)

	self.idToggleTrans = g_Classes.ChoGGi_CheckButton:new({
		Id = "idToggleTrans",
		Text = S[302535920000865--[[Toggle Trans--]]],
		Dock = "left",
		Margins = box(4,0,0,0),
		OnChange = self.idToggleTransOnChange,
	}, self.idButtonContainer)

	self.idToggleTrans:AddInterpolation{
		type = const.intAlpha,
		startValue = 255,
		flags = const.intfIgnoreParent
	}

	self.idShowFileLog = g_Classes.ChoGGi_Button:new({
		Id = "idShowFileLog",
		Dock = "left",
		Text = S[302535920001026--[[Show File Log--]]],
		RolloverText = S[302535920001091--[[Flushes log to disk and displays in console log.--]]],
		OnPress = self.idShowFileLogOnPress,
	}, self.idButtonContainer)

	self.idShowModsLog = g_Classes.ChoGGi_Button:new({
		Id = "idShowModsLog",
		Dock = "left",
		Text = S[302535920000071--[[Mods Log--]]],
		RolloverText = S[302535920000870--[[Shows any errors from loading mods in console log.--]]],
		OnPress = self.idShowModsLogOnPress,
	}, self.idButtonContainer)

	self.idClearLog = g_Classes.ChoGGi_Button:new({
		Id = "idClearLog",
		Dock = "left",
		Text = S[302535920000734--[[Clear Log--]]],
		RolloverText = S[302535920000477--[[Clear out the windowed console log.--]]],
		OnPress = self.idClearLogOnPress,
	}, self.idButtonContainer)

	self.idCopyText = g_Classes.ChoGGi_Button:new({
		Id = "idCopyText",
		Dock = "left",
		Text = S[302535920000563--[[Copy Log Text--]]],
		RolloverText = S[302535920001154--[[Displays the log text in a window you can copy sections from.--]]],
		OnPress = self.idCopyTextOnPress,
	}, self.idButtonContainer)

	-- text box with log in it
	self:AddScrollText()

	-- look at them sexy internals
	self.transp_mode = ChoGGi.Temp.transp_mode
	self:SetTranspMode(self.transp_mode)

end

function ChoGGi_ConsoleLogWin:idToggleTransOnChange()
	self = GetRootDialog(self)
	self.transp_mode = not self.transp_mode
	self:SetTranspMode(self.transp_mode)
end
function ChoGGi_ConsoleLogWin:idShowFileLogOnPress()
	local _,text = ReadLog()
	GetRootDialog(self):UpdateText(text)
end
function ChoGGi_ConsoleLogWin:idShowModsLogOnPress()
	print(ModMessageLog)
end
function ChoGGi_ConsoleLogWin:idClearLogOnPress()
	GetRootDialog(self).idText:SetText("")
end
function ChoGGi_ConsoleLogWin:idCopyTextOnPress()
	ChoGGi.ComFuncs.OpenInMultiLineTextDlg{text = GetRootDialog(self).idText:GetText()}
end

function ChoGGi_ConsoleLogWin:SetTranspMode(toggle)
	self:ClearModifiers()
	if toggle then
		self:AddInterpolation{
			type = const.intAlpha,
			startValue = 32
		}
		self.idToggleTrans:AddInterpolation{
			type = const.intAlpha,
			startValue = 200,
			flags = const.intfIgnoreParent
		}
	end
	-- update global value (for new windows)
	ChoGGi.Temp.transp_mode = toggle
end

function ChoGGi_ConsoleLogWin:UpdateText(text)
	if text then
		self.idText:SetText(text)
	end

	local y = Max(0, self.idScrollArea.scroll_range_y - self.idScrollArea.content_box:sizey())
	self.idScrollV:SetScroll(0, y)
	self.idScrollArea:ScrollTo(0, y)
end

dlgChoGGi_ConsoleLogWin = rawget(_G, "dlgChoGGi_ConsoleLogWin") or false
function OnMsg.ConsoleLine(text, bNewLine)
	local dlg = dlgChoGGi_ConsoleLogWin
	if dlg then
		local old_text = dlg.idText:GetText()

		if bNewLine then
			text = StringFormat("%s\n%s",old_text,text)
		else
			text = StringFormat("%s%s",old_text,text)
		end

		dlg:UpdateText(text)
	end
end

function ChoGGi_ConsoleLogWin:Done(result)
	local ChoGGi = ChoGGi
	-- closing means user doesn't want to see it next time (probably)
	ChoGGi.UserSettings.ConsoleHistoryWin = false
	dlgChoGGi_ConsoleLogWin = false
	ChoGGi.SettingFuncs.WriteSettings()
	-- save the dimensions
	ChoGGi.UserSettings.ConsoleLogWin_Pos = self:GetPos()
	ChoGGi.UserSettings.ConsoleLogWin_Size = self:GetSize()
	ChoGGi_Window.Done(self,result)
end
