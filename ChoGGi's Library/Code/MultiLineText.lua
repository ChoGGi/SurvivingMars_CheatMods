-- See LICENSE for terms

-- displays text in an editable text box

local S = ChoGGi.Strings
local Translate = ChoGGi.ComFuncs.Translate

local CreateRealTimeThread = CreateRealTimeThread
local Sleep = Sleep

local IsControlPressed = ChoGGi.ComFuncs.IsControlPressed
local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
local function GetRootDialog(dlg)
	return GetParentOfKind(dlg,"ChoGGi_MultiLineTextDlg")
end

DefineClass.ChoGGi_MultiLineTextDlg = {
	__parents = {"ChoGGi_Window"},
	retfunc = false,
	overwrite = false,
	context = false,
	dialog_width = 800.0,
	dialog_height = 600.0,

	plugin_names = {"ChoGGi_CodeEditorPlugin"},
}

function ChoGGi_MultiLineTextDlg:Init(parent, context)
	local ChoGGi = ChoGGi
	local g_Classes = g_Classes
--~ 	self.context = context

	-- store func for calling from :OnShortcut
	self.retfunc = context.custom_func
	-- overwrite dumped file
	self.overwrite = context.overwrite

	self.title = context.title or 302535920001301--[[Edit Text--]]

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self:AddScrollEdit()
	self.idEdit:SetText(context.text)

	do -- search area
		self.idSearchArea = g_Classes.ChoGGi_DialogSection:new({
			Id = "idSearchArea",
			Dock = "top",
		}, self.idDialog)
		--
		self.idSearchText = g_Classes.ChoGGi_TextInput:new({
			Id = "idSearchText",
			RolloverText = S[302535920001529--[["Press <color 0 200 0>Enter</color> to select next found text, and <color 0 200 0>Ctrl-Enter</color> to scroll to previous found text."--]]],
			Hint = S[302535920000044--[[Go To Text--]]],
			OnKbdKeyDown = self.idSearchTextOnKbdKeyDown,
		}, self.idSearchArea)
		--
		self.idSearch = g_Classes.ChoGGi_Button:new({
			Id = "idSearch",
			Text = Translate(10123--[[Search--]]),
			Dock = "right",
			RolloverAnchor = "right",
			RolloverHint = S[302535920001424--[["<left_click> Next, <right_click> Previous, <middle_click> Top"--]]],
			RolloverText = S[302535920000045--[["Scrolls down one line or scrolls between text in ""Go to text"".
Right-click <right_click> to go up, middle-click <middle_click> to scroll to the top."--]]],
			OnMouseButtonDown = self.idSearchOnMouseButtonDown,
		}, self.idSearchArea)
	end

	self.idButtonContainer = g_Classes.ChoGGi_DialogSection:new({
		Id = "idButtonContainer",
		Dock = "bottom",
	}, self.idDialog)

	self.idOkay = g_Classes.ChoGGi_Button:new({
		Id = "idOkay",
		Dock = "left",
		Text = Translate(6878--[[OK--]]),
		Background = g_Classes.ChoGGi_Button.bg_green,
		RolloverText = context.hint_ok or Translate(6878--[[OK--]]),
		OnPress = self.idOkayOnPress,
	}, self.idButtonContainer)

	if context.checkbox then
		self.idOverwrite = g_Classes.ChoGGi_CheckButton:new({
			Id = "idOverwrite",
			Dock = "left",
			Margins = box(4,0,0,0),
			Text = S[302535920000721--[[Overwrite--]]],
			RolloverText = S[302535920000827--[[Check this to overwrite file instead of appending to it.--]]],
			OnChange = self.idOverwriteOnChange,
		}, self.idButtonContainer)
	end

	self.idWrapLines = g_Classes.ChoGGi_CheckButton:new({
		Id = "idWrapLines",
		Dock = "left",
		Text = S[302535920001288--[[Wrap Lines--]]],
		RolloverText = S[302535920001289--[[Wrap lines or show horizontal scrollbar.--]]],
		Margins = box(10,0,0,0),
		OnChange = self.idWrapLinesOnChange,
	}, self.idButtonContainer)
	self.idWrapLines:SetIconRow(ChoGGi.UserSettings.WordWrap and 2 or 1)

	self.idToggleCode = g_Classes.ChoGGi_CheckButton:new({
		Id = "idToggleCode",
		Dock = "left",
		Text = S[302535920001474--[[Code Highlight--]]],
		RolloverText = S[302535920001475--[[Toggle lua code highlighting.--]]],
		Margins = box(10,0,0,0),
		OnChange = self.idToggleCodeOnChange,
	}, self.idButtonContainer)

	self.idCancel = g_Classes.ChoGGi_Button:new({
		Id = "idCancel",
		Dock = "right",
		Text = Translate(6879--[[Cancel--]]),
		Background = g_Classes.ChoGGi_Button.bg_red,
		RolloverText = context.hint_cancel or S[302535920001423--[[Close without doing anything.--]]],
		OnPress = self.idCancelOnPress,
	}, self.idButtonContainer)

	if context.scrollto then
		self:ScrollToText(context.scrollto)
	end

	if context.code then
		self:ShowCodeHighlights()
	end

	self:PostInit(context.parent)
end

function ChoGGi_MultiLineTextDlg:idSearchOnMouseButtonDown(pt,button,...)
	ChoGGi_Button.OnMouseButtonDown(self,pt,button,...)
	self = GetRootDialog(self)
	if button == "L" then
		self:FindNext()
	elseif button == "R" then
		self:FindNext(nil,true)
	else
		self:ScrollToText(0)
	end
end

function ChoGGi_MultiLineTextDlg:FindNext(text,previous)
	text = text or self.idSearchText:GetText()
	local edit = self.idEdit
	local current_y = edit.cursor_line

	local min_match, closest_match = false, false
	for i = 1, #edit.lines do

		if edit.lines[i]:find_lower(text) or text == "" then
			if not min_match or i < min_match then
				min_match = i
			end

			if previous then
				if i < current_y and (not closest_match or i > closest_match) then
					closest_match = i
				end
			else
				if i > current_y and (not closest_match or i < closest_match) then
					closest_match = i
				end
			end

		end

	end

	local match = closest_match or min_match
	if match then
		self:ScrollToText(match)
	end
end

function ChoGGi_MultiLineTextDlg:idSearchTextOnKbdKeyDown(vk,...)
	self = GetRootDialog(self)

	local c = const
	if vk == c.vkEnter then
		if IsControlPressed() then
			self:FindNext(nil,true)
		else
			self:FindNext()
		end
		return "break"
	elseif vk == c.vkEsc then
		self.idCloseX:OnPress()
		return "break"
	elseif vk == c.vkV then
		if IsControlPressed() then
			CreateRealTimeThread(function()
				WaitMsg("OnRender")
				self:FindNext()
			end)
		end
	end

	return ChoGGi_TextInput.OnKbdKeyDown(self.idSearchText,vk,...)
end

-- searches for text or goes to line number
function ChoGGi_MultiLineTextDlg:ScrollToText(scrollto)
	CreateRealTimeThread(function()
		Sleep(1)
		local edit = GetRootDialog(self).idEdit
		local line_num
		if type(scrollto) == "string" then
			-- loop through lines table till we find the one we want
			local lines = edit.lines
			for i = 1, #lines do
				local line = lines[i]
				if line:find(scrollto,1,true) then
					line_num = i
					break
				end
			end
		else
			line_num = scrollto
		end

		if line_num then
			edit:SetCursor(line_num, 0, false)
			edit:SetCursor(line_num,edit.line_widths[line_num], true)
			-- ScrollCursorIntoView needs focus for whatever reason
			edit:SetFocus()
			edit:ScrollCursorIntoView()
		end

	end)
end

-- this gets sent to Dump()
function ChoGGi_MultiLineTextDlg:idOverwriteOnChange()
	self = GetRootDialog(self)
	if self.overwrite then
		self.overwrite = false
	else
		self.overwrite = "w"
	end
end

-- maybe i should make this do something for the displayed text...
function ChoGGi_MultiLineTextDlg:idWrapLinesOnChange(check)
	ChoGGi.UserSettings.WordWrap = check
	GetRootDialog(self).idEdit:SetWordWrap(check)
end

-- toggle code highlighting
function ChoGGi_MultiLineTextDlg:idToggleCodeOnChange(check)
	self = GetRootDialog(self)
	if check then
		self.idEdit:SetPlugins(self.plugin_names)
	else
		self.idEdit:RemovePlugin("ChoGGi_CodeEditorPlugin")
	end
end
-- for external use
function ChoGGi_MultiLineTextDlg:ShowCodeHighlights()
	self = GetRootDialog(self)
	self.idEdit:SetPlugins(self.plugin_names)
	self.idToggleCode:SetCheck(true)
end

--
function ChoGGi_MultiLineTextDlg:idOkayOnPress()
	GetRootDialog(self):Done("ok",true)
end

--
function ChoGGi_MultiLineTextDlg:idCancelOnPress()
	GetRootDialog(self):Done("cancel",false)
end

-- goodbye everybody
function ChoGGi_MultiLineTextDlg:Done(result,answer)
	-- for dumping text from examine
	if self.retfunc then
		self.retfunc(answer,self.overwrite,self)
	end
	ChoGGi_Window.Done(self,result)
end
