-- See LICENSE for terms

-- displays text in an editable text box

local S = ChoGGi.Strings
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

	self.idButtonContainer = g_Classes.ChoGGi_DialogSection:new({
		Id = "idButtonContainer",
		Dock = "bottom",
	}, self.idDialog)

	self.idOkay = g_Classes.ChoGGi_Button:new({
		Id = "idOkay",
		Dock = "left",
		Text = S[6878--[[OK--]]],
		RolloverText = ChoGGi.ComFuncs.CheckText(context.hint_ok,S[6878--[[OK--]]]),
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
		Text = S[6879--[[Cancel--]]],
		RolloverText = ChoGGi.ComFuncs.CheckText(context.hint_cancel,S[302535920001423--[[Close without doing anything.--]]]),
		OnPress = self.idCancelOnPress,
	}, self.idButtonContainer)

	self:SetInitPos(context.parent)

	if context.scrollto then
		DelayedCall(1,function()
			self.idEdit:ScrollTo(0, context.scrollto)
		end)
	end

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
