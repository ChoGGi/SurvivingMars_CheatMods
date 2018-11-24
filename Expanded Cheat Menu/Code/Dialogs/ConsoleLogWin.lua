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

local GetRootDialog = function(obj)
	return GetParentOfKind(obj,"ChoGGi_ConsoleLogWin")
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
		OnMouseButtonDown = self.idShowFileLogOnMouseButtonDown,
	}, self.idButtonContainer)

	self.idShowModsLog = g_Classes.ChoGGi_Button:new({
		Id = "idShowModsLog",
		Dock = "left",
		Text = S[302535920000071--[[Mods Log--]]],
		RolloverText = S[302535920000870--[[Shows any errors from loading mods in console log.--]]],
		OnMouseButtonDown = self.idShowModsLogOnMouseButtonDown,
	}, self.idButtonContainer)

	self.idClearLog = g_Classes.ChoGGi_Button:new({
		Id = "idClearLog",
		Dock = "left",
		Text = S[302535920000734--[[Clear Log--]]],
		RolloverText = S[302535920000477--[[Clear out the windowed console log.--]]],
		OnMouseButtonDown = self.idClearLogOnMouseButtonDown,
	}, self.idButtonContainer)

	self.idCopyText = g_Classes.ChoGGi_Button:new({
		Id = "idCopyText",
		Dock = "left",
		Text = S[302535920000563--[[Copy Log Text--]]],
		RolloverText = S[302535920001154--[[Displays the log text in a window you can copy sections from.--]]],
		OnMouseButtonDown = self.idCopyTextOnMouseButtonDown,
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
function ChoGGi_ConsoleLogWin:idShowFileLogOnMouseButtonDown()
	if blacklist then
		print(S[302535920000242--[[%s is blocked by SM function blacklist; use ECM HelperMod to bypass or tell the devs that ECM is awesome and it should have Über access.--]]]:format("Show File Log"))
		return
	end
	FlushLogFile()
	print(select(2,AsyncFileToString(GetLogFile())))
end
function ChoGGi_ConsoleLogWin:idShowModsLogOnMouseButtonDown()
	print(ModMessageLog)
end
function ChoGGi_ConsoleLogWin:idClearLogOnMouseButtonDown()
	GetRootDialog(self).idText:SetText("")
end
function ChoGGi_ConsoleLogWin:idCopyTextOnMouseButtonDown()
	ChoGGi.ComFuncs.SelectConsoleLogText()
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
dlgChoGGi_ConsoleLogWin = rawget(_G, "dlgChoGGi_ConsoleLogWin") or false

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

function OnMsg.ConsoleLine(text, bNewLine)
	local dlg = dlgChoGGi_ConsoleLogWin
	if dlg then
		local old_text = dlg.idText:GetText()

		if bNewLine then
			text = StringFormat("%s\n%s",old_text,text)
		else
			text = StringFormat("%s%s",old_text,text)
		end
		dlg.idText:SetText(text)

		-- always scroll to end of text
		dlg.idScrollArea:ScrollTo(0, #text)
		-- update thumb scroll length
		dlg.idScrollV:SetScrollRange(0, #text)
	end
end
