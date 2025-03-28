-- See LICENSE for terms

-- displays the console in a dialog

local ChoGGi_Funcs = ChoGGi_Funcs
local T = T
local Translate = ChoGGi_Funcs.Common.Translate
local IsValidXWin = ChoGGi_Funcs.Common.IsValidXWin

local GetParentOfKind = ChoGGi_Funcs.Common.GetParentOfKind
local function GetRootDialog(dlg)
	return dlg.parent_dialog or GetParentOfKind(dlg, "ChoGGi_DlgConsoleLogWin")
end
DefineClass.ChoGGi_DlgConsoleLogWin = {
	__parents = {"ChoGGi_XWindow"},
	update_thread = false,

	dialog_width = 700.0,
	dialog_height = 500.0,
}

function ChoGGi_DlgConsoleLogWin:Init(parent, context)
	local g_Classes = g_Classes

	self.title = T(302535920001120--[[Console Window]])

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.idButtonContainer = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idButtonContainer",
		Dock = "top",
	}, self.idDialog)

	self.idShowFileLog = g_Classes.ChoGGi_XButton:new({
		Id = "idShowFileLog",
		Dock = "left",
		Text = T(302535920001026--[[Update Text]]),
		RolloverText = T(302535920001091--[[Flushes log to disk and displays in console log.]]),
		OnPress = self.idShowFileLog_OnPress,
	}, self.idButtonContainer)

	self.idShowModsLog = g_Classes.ChoGGi_XButton:new({
		Id = "idShowModsLog",
		Dock = "left",
		Text = T(302535920000071--[[Show Mods Log]]),
		RolloverText = T(302535920001123--[[Shows any mod msgs in the log.]]),
		OnPress = self.idShowModsLog_OnPress,
	}, self.idButtonContainer)

	self.idButtonSpacer = g_Classes.ChoGGi_XSpacer:new({
		Margins = box(8, 0, 0, 0),
		Dock = "left",
	}, self.idButtonContainer)

	self.idClearLog = g_Classes.ChoGGi_XButton:new({
		Id = "idClearLog",
		Dock = "left",
		Text = T(302535920000734--[[Clear Log]]),
		RolloverText = T(302535920000477--[[Clear out the windowed console log.]]),
		OnPress = self.idClearLog_OnPress,
	}, self.idButtonContainer)

	self.idClipboardCopy = g_Classes.ChoGGi_XButton:new({
		Id = "idClipboardCopy",
		Dock = "left",
		Text = T(302535920000664--[[Clipboard]]),
		RolloverText = T(302535920000406--[[Copy text to the clipboard.]]),
		OnPress = self.idClipboardCopy_OnPress,
	}, self.idButtonContainer)

	-- text box with log in it
	self:AddScrollEdit()
--~ 	self:AddScrollText()

	self.idTextInputArea = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idTextInputArea",
		Dock = "bottom",
	}, self.idDialog)

	self.idTextInput = g_Classes.ChoGGi_XTextInput:new({
		Id = "idTextInput",
		OnKbdKeyDown = self.idTextInput_OnKbdKeyDown,
		RolloverTemplate = "Rollover",
		RolloverTitle = T(302535920001073--[[Console]]) .. " " .. T(487939677892--[[Help]]),
	}, self.idTextInputArea)

	-- add tooltip
	self.idTextInput.RolloverText = T(302535920001440--[["~obj opens object in examine dlg.
~~obj opens object's attachments in examine dlg.

<green>&</green><yellow>handle</yellow> examine object using handle id.

@GetMissionSponsor prints file name and line number of function.

@@EntityData prints type(EntityData).

%""UI/Vignette.tga"" opens image in image viewer.

$123 or $EffectDeposit.display_name prints translated string.

""*r Sleep(1000) print(""sleeping"")"" to wrap in a real time thread (or *g or *m).

!UICity.labels.TerrainDeposit[1] move camera and select obj.

s = SelectedObj, c() = GetCursorWorldPos(), restart() = quit(""restart"")"]])
	self.idTextInput.Hint = Translate(302535920001439--[["~obj, @func, @@type, %image, *r/*g/*m threads. Hover mouse for more info."]])

	self:PostInit()
end

function ChoGGi_DlgConsoleLogWin:idTextInput_OnKbdKeyDown(vk, ...)
	local dlgConsole = dlgConsole
	if not dlgConsole then
		return g_Classes.ChoGGi_XTextInput.OnKbdKeyDown(self, vk, ...)
	end
	local input = GetRootDialog(self).idTextInput

	if vk == const.vkEnter then
		local text = input:GetText()
		if text ~= "" then
			dlgConsole:Exec(text)
		end
--~ 		-- clear text
--~ 		text:SetText("")
		return "break"
	elseif vk == const.vkUp then
		if dlgConsole.history_queue_idx + 1 <= #dlgConsole.history_queue then
			dlgConsole.history_queue_idx = dlgConsole.history_queue_idx + 1
		else
			dlgConsole.history_queue_idx = 1
		end
		local text = dlgConsole.history_queue[dlgConsole.history_queue_idx] or ""
		input:SetText(text)
		input:SetCursor(1, #text)
		return "break"
	elseif vk == const.vkDown then
		if dlgConsole.history_queue_idx <= 1 then
			dlgConsole.history_queue_idx = #dlgConsole.history_queue
		else
			dlgConsole.history_queue_idx = dlgConsole.history_queue_idx - 1
		end
		local text = dlgConsole.history_queue[dlgConsole.history_queue_idx] or ""
		input:SetText(text)
		input:SetCursor(1, #text)
		return "break"
	end

	return g_Classes.ChoGGi_XTextInput.OnKbdKeyDown(self, vk, ...)
end

function ChoGGi_DlgConsoleLogWin:idShowFileLog_OnPress()
	GetRootDialog(self):UpdateText(LoadLogfile())
end
function ChoGGi_DlgConsoleLogWin:idShowModsLog_OnPress()
	self = GetRootDialog(self)

	self:UpdateText(
		self.idEdit:GetText() .. "\n\nModMessageLog:\n"
			.. table.concat(ModMessageLog, "\n")
	)
end
function ChoGGi_DlgConsoleLogWin:idClearLog_OnPress()
	GetRootDialog(self).idEdit:SetText("")
end
function ChoGGi_DlgConsoleLogWin:idClipboardCopy_OnPress()
	CopyToClipboard(GetRootDialog(self).idEdit:GetText())
end

function ChoGGi_DlgConsoleLogWin:UpdateText(text)
	if text then
		self.idEdit:SetText(text)
		CreateRealTimeThread(function()
--~ 			WaitMsg("OnRender")
			self:ScrollToBottom()
		end)
	end
end

function ChoGGi_DlgConsoleLogWin:ScrollToBottom()
--~ 	local y = Max(0, self.idScrollArea.scroll_range_y - self.idScrollArea.content_box:sizey())
--~ 	self.idScrollArea:ScrollTo(0, y)
	local y = Max(0, self.idEdit.scroll_range_y - self.idEdit.content_box:sizey())
	self.idEdit:ScrollTo(0, y)
	self.idScrollV:SetScroll(y)
end

function ChoGGi_DlgConsoleLogWin:Done()
	-- closing means user doesn't want to see it next time (probably)
	ChoGGi.UserSettings.ConsoleHistoryWin = false
	dlgChoGGi_DlgConsoleLogWin = false

	Msg("ChoGGi_DlgConsoleLogWin_SizePos", self)

	ChoGGi_Funcs.Settings.WriteSettings()
end

dlgChoGGi_DlgConsoleLogWin = rawget(_G, "dlgChoGGi_DlgConsoleLogWin") or false
function OnMsg.ConsoleLine(text, bNewLine)
	local dlg = dlgChoGGi_DlgConsoleLogWin
	if not IsValidXWin(dlg) then
		return
	end

	local old_text = dlg.idEdit:GetText()

	if bNewLine then
		text = old_text .. "\n" .. text
	else
		text = old_text .. text
	end

	dlg:UpdateText(text)

	ChoGGi.UserSettings.ConsoleLogWin_Size = dlg:GetSize()
end

function OnMsg.ChoGGi_DlgConsoleLogWin_SizePos(dlg)
	-- don't save size when rolled up
	if not dlg.dialog_rolled_up then
		ChoGGi.UserSettings.ConsoleLogWin_Size = dlg:GetSize()
	end
	ChoGGi.UserSettings.ConsoleLogWin_Pos = dlg:GetPos()
	-- ChoGGi_Funcs.Settings.WriteSettings() is called after each time this msg is called
end

function ChoGGi_Funcs.Common.ShowConsoleLogWin(visible)
	if visible and not dlgChoGGi_DlgConsoleLogWin then
		dlgChoGGi_DlgConsoleLogWin = ChoGGi_DlgConsoleLogWin:new({}, terminal.desktop, {})
		dlgChoGGi_DlgConsoleLogWin:UpdateText(LoadLogfile())
	end

	local dlg = dlgChoGGi_DlgConsoleLogWin
	if dlg then
		dlg:SetVisible(visible)

		local size = ChoGGi.UserSettings.ConsoleLogWin_Size
		if size then
			dlg:SetSize(size)
		end
		local pos = ChoGGi.UserSettings.ConsoleLogWin_Pos
		if pos then
			dlg:SetPos(pos)
		else
			dlg:SetPos(point(100, 100))
		end

	end
end
