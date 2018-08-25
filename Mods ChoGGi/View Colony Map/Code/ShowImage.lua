local dark_gray = -13158858
local medium_gray = -10592674
local light_gray = -2368549
local invis_less = 268435456

DefineClass.ChoGGi_ShowImage = {
	__parents = {"XWindow"},
	dialog_width = 500.0,
	dialog_height = 500.0,
}

function ChoGGi_ShowImage:Init(parent, context)
	local g_Classes = g_Classes

	-- add container dialog for everything to fit in
	self.idDialog = g_Classes.XDialog:new({
		Translate = false,
		MinHeight = 50,
		MinWidth = 150,
		BackgroundColor = invis_less,
		Dock = "ignore",
		RolloverTemplate = "Rollover",

		Background = dark_gray,
		BorderWidth = 2,
		BorderColor = light_gray,
	}, self)
	-- needed for :Wait()
	self.idDialog:Open()
	self.idDialog:SetBox(100, 100, self.dialog_width, self.dialog_height)

	self.idSizeControl = g_Classes.XSizeControl:new({
	}, self.idDialog)

	self.idTitleArea = g_Classes.XWindow:new({
		Id = "idTitleArea",
		Dock = "top",
		Background = medium_gray,
		Margins = box(0,0,0,0),
	}, self.idDialog)

	self.idMoveControl = g_Classes.XMoveControl:new({
		MinHeight = 30,
		Margins = box(0, -30, 0, 0),
		VAlign = "top",
	}, self.idTitleArea)

	self.idCloseX = g_Classes.XTextButton:new({
		RolloverText = TranslationTable[1011--[[Close--]]],
		RolloverAnchor = "right",
		Image = "UI/Common/mission_no.tga",
		Dock = "top",
		HAlign = "right",
		Margins = box(0, 1, 1, 0),

		OnPress = context.func or function()
			self:Close("cancel",false)
		end,
	}, self.idTitleArea)


	self.idImage = g_Classes.XFrame:new({
		Id = "idImage",
	}, self.idDialog)

end
