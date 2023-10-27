-- See LICENSE for terms

-- displays texture info

local T = T
local Translate = ChoGGi.ComFuncs.Translate

DefineClass.ChoGGi_DlgDTMSlots = {
	__parents = {"ChoGGi_XWindow"},

	dialog_width = false,
	dialog_height = false,
}

function ChoGGi_DlgDTMSlots:Init(parent, context)
	local g_Classes = g_Classes

	self.title = T(302535920001486--[[DTM Slots]])

	local screen = UIL.GetScreenSize()
	self.dialog_width = screen:x() - 20 + 0.0
	self.dialog_height = screen:y() - 20 + 0.0

	-- By the Power of Grayskull!
	self:AddElements(parent, context)

	self.idInfo = g_Classes.ChoGGi_XDialogSection:new({
		Id = "idInfo",
	}, self.idDialog)

	-- Invis background
	self.idDialog:SetBackground(0)

	self:PostInit(context.parent)
end

function ChoGGi_DlgDTMSlots:DrawContent()
	local l_dbgDrawSlots = UIL.l_dbgDrawSlots
	local levels = DTM.GetSlotLevels()
	local bbox = self.idInfo.content_box
	self:Invalidate()
	UIL.DrawSolidRect(bbox, 134217728)
	local s = hr.DTM_MaxSlotSize
	local i = 0
	local x, y = bbox:minxyz()
	local w, h = bbox:sizexyz()
	h = h / levels
	while s >= hr.DTM_MinSlotSize do
		local b = box(x,
			y + i * h,
			x + w,
			y + (i + 1) * h
		)
		l_dbgDrawSlots(b, s)
		s = s / 2
		i = i + 1
	end
end
