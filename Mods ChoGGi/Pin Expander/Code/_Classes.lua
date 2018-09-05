-- See LICENSE for terms

--~ box(left, top, right, bottom) :minx() :miny() :sizex() :sizey()

local CheckText = PinExpander.ComFuncs.CheckText
local Trans = PinExpander.ComFuncs.Translate
--~ local S = PinExpander.Strings

local text = "Editor12Bold"

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
local invis_less = 268435456


local Info = Trans(126095410863--[[Info--]])


DefineClass.PinExpander_Text = {
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
	RolloverTitle = Info,
}
--~ function XText:OnHyperLinkRollover(hyperlink, hyperlink_box, pos)
--~ end
DefineClass.PinExpander_Label = {
	__parents = {"XLabel"},
	TextFont = "Editor14Bold",
	Translate = false,
	TextColor = white,
	VAlign = "center",
}
function PinExpander_Label:SetTitle(win,title)
	if win.prefix then
		win.idCaption:SetText(string.format("%s: %s",CheckText(win.prefix,""),CheckText(title or win.title,"")))
	else
		win.idCaption:SetText(CheckText(win.title,""))
	end
end
DefineClass.PinExpander_Image = {
	__parents = {"XImage"},
	Column = 1,
	Columns = 2,
	VAlign = "center",
	HandleKeyboard = false,
	ImageScale = point(250, 250),
	Margins = box(4, 0, 0, 0),
}

DefineClass.PinExpander_MoveControl = {
	__parents = {"XMoveControl"},
	Dock = "top",
	Background = medium_gray,
	FocusedBackground = dark_blue,
	FocusedColor = light_gray,
	RolloverTitle = Trans(126095410863--[[Info--]]),
	RolloverTemplate = "Rollover",
}


DefineClass.PinExpander_CloseButton = {
	__parents = {"PinExpander_Buttons"},
	Image = "UI/Common/mission_no.tga",
	VAlign = "center",
	HAlign = "right",
	Margins = box(0, 0, 2, 0),
	RolloverAnchor = "right",
	RolloverText = Trans(1011--[[Close--]]),
}

DefineClass.PinExpander_MultiLineEdit = {
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

DefineClass.PinExpander_Buttons = {
	__parents = {"XTextButton"},
	RolloverTitle = Info,
	RolloverTemplate = "Rollover",
	RolloverBackground = rollover_blue,
	RolloverTextColor = white,
	Margins = box(4,4,4,4),
	PressedBackground = medium_gray,
	PressedTextColor = white,
}

DefineClass.PinExpander_Button = {
	__parents = {"PinExpander_Buttons"},
	RolloverAnchor = "bottom",
	MinWidth = 60,
	Text = Trans(6878--[[OK--]]),
	Background = light_gray,
}
function PinExpander_Button:Init()
	self.idLabel:SetDock("box")
end

DefineClass.PinExpander_ConsoleButton = {
	__parents = {"PinExpander_Button"},
	Padding = box(5, 2, 5, 2),
	TextFont = "Editor16Bold",
	RolloverAnchor = "right",
	BorderWidth = 1,
	BorderColor = black,
	RolloverBorderColor = black,
	Margins = box(4,0,0,0),
}

DefineClass.PinExpander_ButtonMenu = {
	__parents = {"PinExpander_Button"},
	LayoutMethod = "HList",
	RolloverAnchor = "smart",
	TextFont = "Editor16Bold",
	TextColor = black,
	Margins = box(0,0,0,0),
}
DefineClass.PinExpander_ComboButton = {
	__parents = {"XComboButton"},
	Background = light_gray,

	RolloverBackground = rollover_blue,
	RolloverTextColor = white,
	RolloverAnchor = "top",
	RolloverTitle = Info,
	RolloverTemplate = "Rollover",

	PressedBackground = medium_gray,
	PressedTextColor = white,
	Margins = box(4,4,0,4),
}

DefineClass.PinExpander_CheckButton = {
	__parents = {"XCheckButton"},
	RolloverTitle = Info,
	RolloverTemplate = "Rollover",
	RolloverAnchor = "right",
	RolloverTextColor = light_gray,
	TextColor = white,
	MinWidth = 60,
	Text = Trans(6878--[[OK--]]),
}
function PinExpander_CheckButton:Init()
--~	 XCheckButton.Init(self)
	self.idIcon:SetBackground(light_gray)
end

DefineClass.PinExpander_CheckButtonMenu = {
	__parents = {"PinExpander_CheckButton"},
	RolloverAnchor = "smart",
	Background = light_gray,
	TextHAlign = "left",
	TextFont = "Editor16Bold",
	TextColor = black,
	RolloverBackground = rollover_blue,
	RolloverTextColor = white,
	Margins = box(4,0,0,0),
}

DefineClass.PinExpander_TextInput = {
	__parents = {"XEdit"},
	WordWrap = false,
	AllowTabs = false,
	RolloverTitle = Info,
	RolloverAnchor = "top",
	RolloverTemplate = "Rollover",
	Background = light_gray,
}
--~ function PinExpander_TextInput:Init()
--~	 self:SetText(self.display_text or "")
--~ end

DefineClass.PinExpander_List = {
	__parents = {"XList"},
	RolloverTemplate = "Rollover",
	MinWidth = 50,
  Background = light_gray,
	FocusedBackground = light_gray,
}

DefineClass.PinExpander_Dialog = {
	__parents = {"XDialog"},
	HandleMouse = true,
	Translate = false,
	MinHeight = 50,
	MinWidth = 150,
--~ 	BackgroundColor = invis_less,
	Dock = "ignore",
	RolloverTemplate = "Rollover",
	RolloverTitle = Info,
	Background = dark_gray,
	BorderWidth = 2,
	BorderColor = light_gray,
}

DefineClass.PinExpander_DialogSection = {
	__parents = {"XWindow"},
	HandleMouse = true,
	FoldWhenHidden = true,
	RolloverTemplate = "Rollover",
	RolloverTitle = Info,
}

DefineClass.PinExpander_ScrollArea = {
	__parents = {"XScrollArea"},
--~ 	UniformColumnWidth = true,
--~ 	UniformRowHeight = true,
	Margins = box(4,4,4,4),
	BorderWidth = 0,
}

DefineClass.PinExpander_SleekScroll = {
	__parents = {"XSleekScroll"},
	MinThumbSize = 30,
	AutoHide = true,
	Background = invis,
}
-- convenience function
function PinExpander_SleekScroll:SetHorizontal()
	self.MinHeight = 10
--~	 self.MaxHeight = 10
	self.MinWidth = 10
--~	 self.MaxWidth = 10
end

DefineClass.PinExpander_Window = {
	__parents = {"XWindow"},
	dialog_width = 500.0,
	dialog_height = 500.0,
	-- above console
	ZOrder = 5,
	-- how far down to y-offset new dialogs
	header = 33.0,

	title = Trans(1000016--[[Title--]]),
	RolloverTemplate = "Rollover",
}

function PinExpander_Window:AddElements(_,context)
	local g_Classes = g_Classes

	-- scale to UI
	local UIScale = PinExpander.Temp.UIScale
	self.dialog_width = self.dialog_width * UIScale
	self.dialog_height = self.dialog_height * UIScale
	self.header = self.header * UIScale

	-- add container dialog for everything to fit in
	self.idDialog = g_Classes.PinExpander_Dialog:new({
	}, self)

	-- x,y,w,h (start off with all dialogs at 100,100, default size, and we move later)
	self.idDialog:SetBox(100, 100, self.dialog_width, self.dialog_height)

	self.idSizeControl = g_Classes.XSizeControl:new({
	}, self.idDialog)

	self.idMoveControl = g_Classes.PinExpander_MoveControl:new({
	}, self.idDialog)

	self.idCloseX = PinExpander_CloseButton:new({
		OnPress = context.func or function()
			self:Close("cancel",false)
		end,
	}, self.idMoveControl)

	local image = self.title_image or self.obj and self.obj.display_icon
	if image then
		self.idCaptionImage = g_Classes.PinExpander_Image:new({
			Id = "idCaptionImage",
			Dock = "left",
		}, self.idMoveControl)
		self.idCaptionImage:SetImage(image)
	end

	self.idCaption = g_Classes.PinExpander_Label:new({
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
end

-- returns point(x,y)
function PinExpander_Window:GetPos(dialog)
	local b = self[dialog or "idDialog"].box
	return point(b:minx(),b:miny())
end

-- get size of box and offset header
local function BoxSize(obj,self)
--~ box(left, top, right, bottom) :minx() :miny() :sizex() :sizey()
	local x,y,w,h
	local box = obj.idDialog.box
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
function PinExpander_Window:SetPos(obj)
	local x,y,w,h
	if IsPoint(obj) then
		local box = self.idDialog.box
		x = obj:x()
		y = obj:y()
		w = box:sizex()
		h = box:sizey()
	else
		x,y,w,h = BoxSize(obj,self)
	end
	self.idDialog:SetBox(x,y,w,h)
end

function PinExpander_Window:SetSize(size)
	local box = self.idDialog.box
	local x,y = box:minx(),box:miny()
	local w,h = size:x(),size:y()
	self.idDialog:SetBox(x,y,w,h)
end
function PinExpander_Window:SetWidth(w)
	self:SetSize(point(w,self.idDialog.box:sizey()))
end
function PinExpander_Window:SetHeight(h)
	self:SetSize(point(self.idDialog.box:sizex(),h))
end
function PinExpander_Window:GetSize(dialog)
	local b = self[dialog or "idDialog"].box
	return point(b:sizex(),b:sizey())
end

local GetMousePos = terminal.GetMousePos
local GetSafeAreaBox = GetSafeAreaBox
function PinExpander_Window:SetInitPos(parent)
	local x,y,w,h

	-- if we're opened from another dialog then offset it, else open at mouse cursor
	if parent then
		x,y,w,h = BoxSize(parent,self)
	else
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
function PinExpander_Window:AddScrollText()
	local g_Classes = g_Classes

	self.idScrollSection = g_Classes.PinExpander_DialogSection:new({
		Id = "idScrollSection",
		BorderWidth = 1,
		Margins = box(0,0,0,0),
		BorderColor = light_gray,
	}, self.idDialog)

	self.idScrollArea = g_Classes.PinExpander_ScrollArea:new({
		Id = "idScrollArea",
		VScroll = "idScrollV",
		HScroll = "idScrollH",
	}, self.idScrollSection)

	self.idScrollV = g_Classes.PinExpander_SleekScroll:new({
		Id = "idScrollV",
		Target = "idScrollArea",
		Dock = "right",
	}, self.idScrollSection)

	self.idScrollH = g_Classes.PinExpander_SleekScroll:new({
		Id = "idScrollH",
		Target = "idScrollArea",
		Dock = "bottom",
		Horizontal = true,
	}, self.idScrollSection)

	self.idText = g_Classes.PinExpander_Text:new({
		Id = "idText",
		OnHyperLink = function(_, link, _, box, pos, button)
			self.onclick_handles[tonumber(link)](box, pos, button)
		end,
	}, self.idScrollArea)
end

function PinExpander_Window:AddScrollList()
	local g_Classes = g_Classes

	self.idScrollSection = g_Classes.PinExpander_DialogSection:new({
		Id = "idScrollSection",
		Margins = box(4,4,4,4),
	}, self.idDialog)

	self.idScrollArea = g_Classes.PinExpander_ScrollArea:new({
		Id = "idScrollArea",
		VScroll = "idScrollV",
	}, self.idScrollSection)

	self.idScrollV = g_Classes.PinExpander_SleekScroll:new({
		Id = "idScrollV",
		Target = "idScrollArea",
		Dock = "right",
	}, self.idScrollSection)

	self.idList = g_Classes.PinExpander_List:new({
		Id = "idList",
		VScroll = "idScrollV",
	}, self.idScrollArea)

end

function PinExpander_Window:AddScrollEdit()
	local g_Classes = g_Classes

	self.idScrollSection = g_Classes.PinExpander_DialogSection:new({
		Id = "idScrollSection",
		Margins = box(4,4,4,4),
	}, self.idDialog)

	self.idScrollV = g_Classes.PinExpander_SleekScroll:new({
		Id = "idScrollV",
		Target = "idEdit",
		Dock = "right",
	}, self.idScrollSection)

	self.idScrollH = g_Classes.PinExpander_SleekScroll:new({
		Id = "idScrollH",
		Target = "idEdit",
		Dock = "bottom",
		Horizontal = true,
	}, self.idScrollSection)

	self.idEdit = PinExpander_MultiLineEdit:new({
		Id = "idEdit",
		VScroll = "idScrollV",
		HScroll = "idScrollH",
		Margins = box(4,4,4,4),
		WordWrap = PinExpander.UserSettings.WordWrap or false,
	}, self.idScrollSection)
end
