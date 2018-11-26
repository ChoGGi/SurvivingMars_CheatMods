-- See LICENSE for terms

-- displays text in an editable text box

local S = ChoGGi.Strings
local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind

local GetRootDialog = function(obj)
	return GetParentOfKind(obj,"ChoGGi_MultiLineTextDlg")
end

DefineClass.ChoGGi_MultiLineTextDlg = {
	__parents = {"ChoGGi_Window"},
	retfunc = false,
	overwrite = false,
	context = false,
	dialog_width = 800.0,
	dialog_height = 600.0,
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

--~	 -- let us override enter/esc
--~	 self.idEdit.OnKbdKeyDown = function(obj, vk)
--~		 return ChoGGi_TextInput.OnKbdKeyDown(obj, vk)
--~	 end

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
		self.idChkOverwrite = g_Classes.ChoGGi_CheckButton:new({
			Id = "idChkOverwrite",
			Dock = "left",
			Margins = box(4,0,0,0),
			Text = S[302535920000721--[[Overwrite--]]],
			RolloverText = S[302535920000827--[[Check this to overwrite file instead of appending to it.--]]],
			OnChange = self.idChkOverwriteOnChange,
		}, self.idButtonContainer)
	end

	self.idChkWraplines = g_Classes.ChoGGi_CheckButton:new({
		Id = "idChkWraplines",
		Dock = "left",
		Text = S[302535920001288--[[Wrap Lines--]]],
		RolloverText = S[302535920001289--[[Wrap lines or show horizontal scrollbar.--]]],
		Margins = box(10,0,0,0),
		Check = ChoGGi.UserSettings.WordWrap,
		OnChange = self.idChkWraplinesOnChange,
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

function ChoGGi_MultiLineTextDlg:idChkOverwriteOnChange()
	self = GetRootDialog(self)
	if self.overwrite then
		self.overwrite = false
	else
		self.overwrite = "w"
	end
end
function ChoGGi_MultiLineTextDlg:idOkayOnPress()
	GetRootDialog(self):Done("ok",true)
end
function ChoGGi_MultiLineTextDlg:idChkWraplinesOnChange(which)
	ChoGGi.UserSettings.WordWrap = which
	GetRootDialog(self).idEdit:SetWordWrap(which)
end
function ChoGGi_MultiLineTextDlg:idCancelOnPress()
	GetRootDialog(self):Done("cancel",false)
end

function ChoGGi_MultiLineTextDlg:Done(result,answer)
	if self.retfunc then
		self.retfunc(answer,self.overwrite,self)
	end
	ChoGGi_Window.Done(self,result)
end
