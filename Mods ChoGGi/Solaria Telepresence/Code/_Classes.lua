local light_gray = -2368549
local medium_gray = -10592674
local rollover_blue = -14113793

local Trans = SolariaTelepresence.ComFuncs.Translate

DefineClass.SolariaTelepresence_Buttons = {
	__parents = {"XTextButton"},
	RolloverTitle = Trans(126095410863--[[Info--]]),
	RolloverTemplate = "Rollover",
	RolloverBackground = rollover_blue,
	RolloverTextColor = white,
	Margins = box(4,0,0,0),
	PressedBackground = medium_gray,
	PressedTextColor = white,
}

DefineClass.SolariaTelepresence_Button = {
	__parents = {"SolariaTelepresence_Buttons"},
	RolloverAnchor = "bottom",
	MinWidth = 60,
	Text = Trans(6878--[[OK--]]),
	Background = light_gray,
}
DefineClass.SolariaTelepresence_ButtonMenu = {
	__parents = {"SolariaTelepresence_Button"},
	LayoutMethod = "HList",
	RolloverAnchor = "smart",
	TextFont = "Editor16Bold",
	TextColor = black,
}

DefineClass.SolariaTelepresence_CheckButton = {
	__parents = {"XCheckButton"},
	RolloverTitle = Trans(126095410863--[[Info--]]),
	RolloverTemplate = "Rollover",
	RolloverAnchor = "right",
	RolloverTextColor = light_gray,
	TextColor = white,
	MinWidth = 60,
	Text = Trans(6878--[[OK--]]),
}
function SolariaTelepresence_CheckButton:Init()
--~	 XCheckButton.Init(self)
	self.idIcon:SetBackground(light_gray)
end

DefineClass.SolariaTelepresence_CheckButtonMenu = {
	__parents = {"SolariaTelepresence_CheckButton"},
	RolloverAnchor = "smart",
	Background = light_gray,
	TextHAlign = "left",
	TextFont = "Editor16Bold",
	TextColor = black,
	RolloverBackground = rollover_blue,
	RolloverTextColor = white,
	Margins = box(4,0,0,0),
}

