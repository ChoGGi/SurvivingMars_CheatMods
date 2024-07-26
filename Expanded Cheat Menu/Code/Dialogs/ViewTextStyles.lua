-- See LICENSE for terms

-- See all text styles

local ChoGGi_Funcs = ChoGGi_Funcs

DefineClass.ChoGGi_DlgViewTextStyles = {
	__parents = {"ChoGGi_XWindow"},
	dialog_width = 650.0,
	dialog_height = 850.0,
}

function ChoGGi_DlgViewTextStyles:Init(parent, context)

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self:AddScrollList()

	local TextStyles = TextStyles

	local list = {}
	local c = 0

	for id in pairs(TextStyles) do
		c = c + 1
		list[c] = id
	end

	table.sort(list)
	for i = 1, #list do
		local id = list[i]
		local _, text_ctrl = self.idList:CreateTextItem(id)
		text_ctrl:SetTextStyle(id)
	end

	self:PostInit(context.parent)
end

if false then
	local dlg = ChoGGi_DlgViewTextStyles:new({}, terminal.desktop, {})
	ex(dlg)
end
