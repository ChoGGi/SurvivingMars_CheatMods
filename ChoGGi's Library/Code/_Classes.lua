-- See LICENSE for terms

--~ box(left, top, right, bottom) :minx() :miny() :sizex() :sizey()

local CheckText = ChoGGi.ComFuncs.CheckText
local RetName = ChoGGi.ComFuncs.RetName
local S = ChoGGi.Strings

local text = "Editor12Bold"
if ChoGGi.testing then
	text = "Editor14Bold"
end

local box,point = box,point

local white = white
local black = black
local dark_blue = -12235133
local dark_gray = -13158858
--~ local less_dark_gray = -12500671
local medium_gray = -10592674
local light_gray = -2368549
local rollover_blue = -14113793
local invis = 0
--~ local invis_less = 268435456

DefineClass.ChoGGi_Text = {
	__parents = {"XText"},
	-- default
	Background = dark_gray,
	TextColor = white,
	-- focused
	FocusedBackground = dark_gray,
	RolloverTextColor = white,
	-- selected
	SelectionBackground = light_gray,
	SelectionColor = black,
	TextFont = text,

	RolloverTemplate = "Rollover",
	RolloverTitle = S[126095410863--[[Info--]]],
}
--~ function XText:OnHyperLinkRollover(hyperlink, hyperlink_box, pos)
--~ end

DefineClass.ChoGGi_MultiLineEdit = {
	__parents = {"XMultiLineEdit"},
	TextFont = "Editor16",
	-- default
	Background = dark_gray,
	TextColor = white,
	-- focused
	FocusedBackground = dark_gray,
	RolloverTextColor = white,
	-- selected
	SelectionBackground = light_gray,
	SelectionColor = black,

	MaxLen = -1,
	MaxLines = -1,
	RolloverTemplate = "Rollover",
	WordWrap = false,
}

DefineClass.ChoGGi_Label = {
	__parents = {"XLabel"},
	TextFont = "Editor14Bold",
	Translate = false,
	TextColor = white,
	VAlign = "center",
}
function ChoGGi_Label:SetTitle(win,title)
	if win.prefix then
		win.idCaption:SetText(string.format("%s: %s",CheckText(win.prefix,""),CheckText(title or win.title,RetName(self))))
	else
		win.idCaption:SetText(CheckText(title or win.title,RetName(self)))
	end
end
DefineClass.ChoGGi_Image = {
	__parents = {"XImage"},
	Column = 1,
	Columns = 2,
	VAlign = "center",
	HandleKeyboard = false,
	ImageScale = point(250, 250),
	Margins = box(4, 0, 0, 0),
}
DefineClass.ChoGGi_MoveControl = {
	__parents = {"XMoveControl"},
	Dock = "top",
	Background = medium_gray,
	FocusedBackground = dark_blue,
	FocusedColor = light_gray,
	RolloverTitle = S[126095410863--[[Info--]]],
	RolloverTemplate = "Rollover",
}
function ChoGGi_MoveControl:OnKbdKeyDown(vk,...)
	if vk == const.vkEsc then
		self.dialog.idCloseX:Press()
		return "break"
	end
	return XMoveControl.OnKbdKeyDown(self,vk,...)
end

DefineClass.ChoGGi_Buttons = {
	__parents = {"XTextButton"},
	RolloverTitle = S[126095410863--[[Info--]]],
	RolloverTemplate = "Rollover",
	RolloverBackground = rollover_blue,
	RolloverTextColor = white,
	Margins = box(4,4,4,4),
	PressedBackground = medium_gray,
	PressedTextColor = white,
}

DefineClass.ChoGGi_Button = {
	__parents = {"ChoGGi_Buttons"},
	RolloverAnchor = "bottom",
	MinWidth = 60,
	Text = S[6878--[[OK--]]],
	Background = light_gray,
}
function ChoGGi_Button:Init()
	self.idLabel:SetDock("box")
end

DefineClass.ChoGGi_CloseButton = {
	__parents = {"ChoGGi_Buttons"},
	Image = "UI/Common/mission_no.tga",
	VAlign = "center",
	HAlign = "right",
	Margins = box(0, 0, 2, 0),
	RolloverAnchor = "right",
	RolloverText = S[1011--[[Close--]]],
}

DefineClass.ChoGGi_ConsoleButton = {
	__parents = {"ChoGGi_Button"},
	Padding = box(5, 2, 5, 2),
	TextFont = "Editor16Bold",
	RolloverAnchor = "right",
	BorderWidth = 1,
	BorderColor = black,
	RolloverBorderColor = black,
	Margins = box(4,0,0,0),
}

DefineClass.ChoGGi_ButtonMenu = {
	__parents = {"ChoGGi_Button"},
	LayoutMethod = "HList",
	RolloverAnchor = "smart",
	TextFont = "Editor16Bold",
	TextColor = black,
	Margins = box(0,0,0,0),
}
DefineClass.ChoGGi_ComboButton = {
	__parents = {"XComboButton"},
	Background = light_gray,
	RolloverBackground = rollover_blue,
	RolloverTextColor = white,
	RolloverAnchor = "top",
	RolloverTitle = S[126095410863--[[Info--]]],
	RolloverTemplate = "Rollover",
	PressedBackground = medium_gray,
	PressedTextColor = white,
	Margins = box(4,4,0,4),
}

DefineClass.ChoGGi_CheckButton = {
	__parents = {"XCheckButton"},
	RolloverTitle = S[126095410863--[[Info--]]],
	RolloverTemplate = "Rollover",
	RolloverAnchor = "right",
	RolloverTextColor = light_gray,
	TextColor = white,
	MinWidth = 60,
	Text = S[6878--[[OK--]]],
}
function ChoGGi_CheckButton:Init()
--~	 XCheckButton.Init(self)
	self.idIcon:SetBackground(light_gray)
end

DefineClass.ChoGGi_CheckButtonMenu = {
	__parents = {"ChoGGi_CheckButton"},
	RolloverAnchor = "smart",
	Background = light_gray,
	TextHAlign = "left",
	TextFont = "Editor16Bold",
	TextColor = black,
	RolloverBackground = rollover_blue,
	RolloverTextColor = white,
	Margins = box(4,0,0,0),
}

DefineClass.ChoGGi_TextInput = {
	__parents = {"XEdit"},
	WordWrap = false,
	AllowTabs = false,
	RolloverTitle = S[126095410863--[[Info--]]],
	RolloverAnchor = "top",
	RolloverTemplate = "Rollover",
	Background = light_gray,
}
--~ function ChoGGi_TextInput:Init()
--~	 self:SetText(self.display_text or "")
--~ end

DefineClass.ChoGGi_List = {
	__parents = {"XList"},
	RolloverTemplate = "Rollover",
	MinWidth = 50,
  Background = light_gray,
	FocusedBackground = light_gray,
}

DefineClass.ChoGGi_Dialog = {
	__parents = {"XDialog"},
	HandleMouse = true,
	Translate = false,
	MinHeight = 50,
	MinWidth = 150,
--~ 	BackgroundColor = invis_less,
	Dock = "ignore",
	RolloverTemplate = "Rollover",
	RolloverTitle = S[126095410863--[[Info--]]],
	Background = dark_gray,
	BorderWidth = 2,
	BorderColor = light_gray,
}

DefineClass.ChoGGi_DialogSection = {
	__parents = {"XWindow"},
	HandleMouse = true,
	FoldWhenHidden = true,
	RolloverTemplate = "Rollover",
	RolloverTitle = S[126095410863--[[Info--]]],
}

DefineClass.ChoGGi_ScrollArea = {
	__parents = {"XScrollArea"},
--~ 	UniformColumnWidth = true,
--~ 	UniformRowHeight = true,
	Margins = box(4,4,4,4),
	BorderWidth = 0,
}

DefineClass.ChoGGi_SleekScroll = {
	__parents = {"XSleekScroll"},
	MinThumbSize = 30,
	AutoHide = true,
	Background = invis,
}
-- convenience function
function ChoGGi_SleekScroll:SetHorizontal()
	self.MinHeight = 10
--~	 self.MaxHeight = 10
	self.MinWidth = 10
--~	 self.MaxWidth = 10
end

DefineClass.ChoGGi_Window = {
	__parents = {"XWindow"},
	dialog_width = 500.0,
	dialog_height = 500.0,
	-- above console
	ZOrder = 5,
	-- how far down to y-offset new dialogs
	header = 33.0,

	RolloverTemplate = "Rollover",
}

function ChoGGi_Window:AddElements(_,context)
	local g_Classes = g_Classes

	-- scale to UI
	local UIScale = ChoGGi.Temp.UIScale
	self.dialog_width = self.dialog_width * UIScale
	self.dialog_height = self.dialog_height * UIScale
	self.header = self.header * UIScale

	-- add container dialog for everything to fit in
	self.idDialog = g_Classes.ChoGGi_Dialog:new({
	}, self)

	-- x,y,w,h (start off with all dialogs at 100,100, default size, and we move later)
	self.idDialog:SetBox(100, 100, self.dialog_width, self.dialog_height)

	self.idSizeControl = g_Classes.XSizeControl:new({
	}, self.idDialog)

	self.idMoveControl = g_Classes.ChoGGi_MoveControl:new({
		dialog = self,
	}, self.idDialog)

	self.idCloseX = ChoGGi_CloseButton:new({
		OnPress = context.func or function()
			self:Close("cancel",false)
		end,
	}, self.idMoveControl)

	local image = self.title_image or type(self.obj) == "table" and self.obj.display_icon
	if image then
		self.idCaptionImage = g_Classes.ChoGGi_Image:new({
			Id = "idCaptionImage",
			Dock = "left",
		}, self.idMoveControl)
		self.idCaptionImage:SetImage(image)
	end

	self.idCaption = g_Classes.ChoGGi_Label:new({
		Id = "idCaption",
		MaxHeight = self.header,
		Dock = "left",
	}, self.idMoveControl)
	if image then
		self.idCaption:SetMargins(box(self.idCaptionImage.box:sizex(),0,0,0))
	else
		self.idCaption:SetMargins(box(4,0,0,0))
	end
	self.idCaption:SetTitle(self)

	-- needed for :Wait()
	self.idDialog:Open()

	self.idMoveControl:SetFocus()
end

-- returns point(x,y)
function ChoGGi_Window:GetPos(dialog)
	local b = self[dialog or "idDialog"].box
	return point(b:minx(),b:miny())
end

-- get size of box and offset header
local function BoxSize(obj,self)
--~ box(left, top, right, bottom) :minx() :miny() :sizex() :sizey()
	local obj_dlg = obj.idDialog or obj.idContainer
	if not obj_dlg then
		return
	end

	local x,y,w,h
	local box = obj_dlg.box
	x = box:minx()
	y = box:miny() + self.header
	if self.class == "Examine" then
		-- it's a copy of examine wanting a new window offset, so we want the size of it
		w = box:sizex()
		h = box:sizey()
	else
		-- keep orig size please n thanks
		box = self.idDialog.box
		w = box:sizex()
		h = box:sizey()
	end
	return x,y,w,h
end

-- takes either a point, or obj to set pos
function ChoGGi_Window:SetPos(obj)
	local x,y,w,h = BoxSize(obj,self)

	if not x or IsPoint(obj) then
		local pt = GetMousePos()
		local box = self.idDialog.box
		x = pt:x()
		y = pt:y()
		w = box:sizex()
		h = box:sizey()
	end

	self.idDialog:SetBox(x,y,w,h)
end

function ChoGGi_Window:SetSize(size)
	local box = self.idDialog.box
	local x,y = box:minx(),box:miny()
	local w,h = size:x(),size:y()
	self.idDialog:SetBox(x,y,w,h)
end
function ChoGGi_Window:SetWidth(w)
	self:SetSize(point(w,self.idDialog.box:sizey()))
end
function ChoGGi_Window:SetHeight(h)
	self:SetSize(point(self.idDialog.box:sizex(),h))
end
function ChoGGi_Window:GetSize(dialog)
	local b = self[dialog or "idDialog"].box
	return point(b:sizex(),b:sizey())
end

local GetMousePos = terminal.GetMousePos
local GetSafeAreaBox = GetSafeAreaBox
function ChoGGi_Window:SetInitPos(parent)
	local x,y,w,h

	-- if we're opened from another dialog then offset it, else open at mouse cursor
	if parent then
		x,y,w,h = BoxSize(parent,self)
	end

	if not parent or not x then
		local pt = GetMousePos()
		local box = self.idDialog.box
		x = pt:x()
		y = pt:y()
		w = box:sizex()
		h = box:sizey()
	end

	-- if it's negative then set it to 100
	y = y < 0 and 100 or y
	x = x < 0 and 100 or x

	-- res of game window
	local safe = GetSafeAreaBox()
	local winw = safe:maxx()
	local winh = safe:maxy()

	-- check if dialog is past the edge
	local new_x
	if (x + w) > winw then
		new_x = winw - w
	end
	local new_y
	if (y + h) > winh then
		if IsKindOf(parent,"XWindow") then
			-- shrink box by header
			new_y = winh - h + self.header
			h = h - self.header
		else
			new_y = winh - h
		end
	end

	self.idDialog:SetBox(new_x or x,new_y or y,w,h)
end

-- scrollable textbox
function ChoGGi_Window:AddScrollText()
	local g_Classes = g_Classes

	self.idScrollSection = g_Classes.ChoGGi_DialogSection:new({
		Id = "idScrollSection",
		BorderWidth = 1,
		Margins = box(0,0,0,0),
		BorderColor = light_gray,
	}, self.idDialog)

	self.idScrollArea = g_Classes.ChoGGi_ScrollArea:new({
		Id = "idScrollArea",
		VScroll = "idScrollV",
		HScroll = "idScrollH",
	}, self.idScrollSection)

	self.idScrollV = g_Classes.ChoGGi_SleekScroll:new({
		Id = "idScrollV",
		Target = "idScrollArea",
		Dock = "right",
	}, self.idScrollSection)

	self.idScrollH = g_Classes.ChoGGi_SleekScroll:new({
		Id = "idScrollH",
		Target = "idScrollArea",
		Dock = "bottom",
		Horizontal = true,
	}, self.idScrollSection)

	self.idText = g_Classes.ChoGGi_Text:new({
		Id = "idText",
		OnHyperLink = function(_, link, _, box, pos, button)
			self.onclick_handles[tonumber(link)](box, pos, button)
		end,
	}, self.idScrollArea)
end

function ChoGGi_Window:AddScrollList()
	local g_Classes = g_Classes

	self.idScrollSection = g_Classes.ChoGGi_DialogSection:new({
		Id = "idScrollSection",
		Margins = box(4,4,4,4),
	}, self.idDialog)

	self.idScrollArea = g_Classes.ChoGGi_ScrollArea:new({
		Id = "idScrollArea",
		VScroll = "idScrollV",
	}, self.idScrollSection)

	self.idScrollV = g_Classes.ChoGGi_SleekScroll:new({
		Id = "idScrollV",
		Target = "idScrollArea",
		Dock = "right",
	}, self.idScrollSection)

	self.idList = g_Classes.ChoGGi_List:new({
		Id = "idList",
		VScroll = "idScrollV",
	}, self.idScrollArea)

end

function ChoGGi_Window:AddScrollEdit()
	local g_Classes = g_Classes

	self.idScrollSection = g_Classes.ChoGGi_DialogSection:new({
		Id = "idScrollSection",
		Margins = box(4,4,4,4),
	}, self.idDialog)

	self.idScrollV = g_Classes.ChoGGi_SleekScroll:new({
		Id = "idScrollV",
		Target = "idEdit",
		Dock = "right",
	}, self.idScrollSection)

	self.idScrollH = g_Classes.ChoGGi_SleekScroll:new({
		Id = "idScrollH",
		Target = "idEdit",
		Dock = "bottom",
		Horizontal = true,
	}, self.idScrollSection)

	self.idEdit = ChoGGi_MultiLineEdit:new({
		Id = "idEdit",
		VScroll = "idScrollV",
		HScroll = "idScrollH",
		Margins = box(4,4,4,4),
		WordWrap = ChoGGi.UserSettings.WordWrap or false,
	}, self.idScrollSection)
end
