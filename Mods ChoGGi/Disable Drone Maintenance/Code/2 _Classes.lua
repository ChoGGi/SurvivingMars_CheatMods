-- See LICENSE for terms

--~ box(left, top, right, bottom) :minx() :miny() :sizex() :sizey()

local T = DisableDroneMaintenance.ComFuncs.Translate

local box,point = box,point

local white = -1
local black = black
local dark_gray = -13158858
local medium_gray = -10592674
local light_gray = -2368549
local rollover_blue = -14113793
local invis = 0
local invis_less = 268435456

local text = "Editor12Bold"
DefineClass.DisableDroneMaintenance_Text = {
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
--~	 WordWrap = true,
}

DefineClass.DisableDroneMaintenance_MultiLineEdit = {
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

DefineClass.DisableDroneMaintenance_Buttons = {
	__parents = {"XTextButton"},
	RolloverTitle = T(126095410863--[[Info--]]),
	RolloverTemplate = "Rollover",
	RolloverBackground = rollover_blue,
	RolloverTextColor = white,
	Margins = box(4,0,0,0),
}

DefineClass.DisableDroneMaintenance_CloseButton = {
	__parents = {"DisableDroneMaintenance_Buttons"},
	RolloverText = T(1011--[[Close--]]),
	RolloverAnchor = "right",
	Image = "UI/Common/mission_no.tga",
	Dock = "top",
	HAlign = "right",
	Margins = box(0, 1, 1, 0),
}

DefineClass.DisableDroneMaintenance_Button = {
	__parents = {"DisableDroneMaintenance_Buttons"},
	RolloverAnchor = "bottom",
	MinWidth = 60,
	Text = T(6878--[[OK--]]),
	Background = light_gray,
}
function DisableDroneMaintenance_Button:Init()
	self.idLabel:SetDock("box")
end

DefineClass.DisableDroneMaintenance_ConsoleButton = {
	__parents = {"DisableDroneMaintenance_Button"},
	Padding = box(5, 2, 5, 2),
	TextFont = "Editor16Bold",
	RolloverAnchor = "right",
	PressedBackground = dark_gray,
}

DefineClass.DisableDroneMaintenance_ButtonMenu = {
	__parents = {"DisableDroneMaintenance_Button"},
	LayoutMethod = "HList",
	RolloverAnchor = "smart",
	TextFont = "Editor16Bold",
	TextColor = black,
}
DefineClass.DisableDroneMaintenance_ComboButton = {
	__parents = {"XComboButton"},
	Background = light_gray,
	RolloverBackground = rollover_blue,
	RolloverTextColor = white,
	RolloverAnchor = "top",
	RolloverTitle = T(126095410863--[[Info--]]),
	RolloverTemplate = "Rollover",
}

DefineClass.DisableDroneMaintenance_CheckButton = {
	__parents = {"XCheckButton"},
	RolloverTitle = T(126095410863--[[Info--]]),
	RolloverTemplate = "Rollover",
	RolloverAnchor = "right",
	RolloverTextColor = light_gray,
	TextColor = white,
	MinWidth = 60,
	Text = T(6878--[[OK--]]),
}
DefineClass.DisableDroneMaintenance_CheckButtonMenu = {
	__parents = {"DisableDroneMaintenance_CheckButton"},
	RolloverAnchor = "smart",
	Background = light_gray,
	TextHAlign = "left",
	TextFont = "Editor16Bold",
	TextColor = black,
	RolloverBackground = rollover_blue,
	RolloverTextColor = white,
	Margins = box(4,0,0,0),
}

function DisableDroneMaintenance_CheckButton:Init()
--~	 XCheckButton.Init(self)
	self.idIcon:SetBackground(light_gray)
end

DefineClass.DisableDroneMaintenance_TextInput = {
	__parents = {"XEdit"},
	WordWrap = false,
	AllowTabs = false,
	RolloverTitle = T(126095410863--[[Info--]]),
	RolloverAnchor = "top",
	RolloverTemplate = "Rollover",
}
--~ function DisableDroneMaintenance_TextInput:Init()
--~	 self:SetText(self.display_text or "")
--~ end

DefineClass.DisableDroneMaintenance_List = {
	__parents = {"XList"},
	RolloverTemplate = "Rollover",
	MinWidth = 50,
  Background = light_gray,
	FocusedBackground = light_gray,
}

DefineClass.DisableDroneMaintenance_Dialog = {
	__parents = {"XDialog"},
	Translate = false,
	MinHeight = 50,
	MinWidth = 150,
	BackgroundColor = invis_less,
--~	 HAlign = "left",
--~	 VAlign = "top",
	Dock = "ignore",
	RolloverTemplate = "Rollover",
}

DefineClass.DisableDroneMaintenance_DialogSection = {
	__parents = {"XWindow"},
	Margins = box(4,4,4,4),
	FoldWhenHidden = true,
	RolloverTemplate = "Rollover",
}

DefineClass.DisableDroneMaintenance_Window = {
	__parents = {"XWindow"},
	dialog_width = 500,
	dialog_height = 500,
	-- above console
	ZOrder = 5,
	-- how far down to y-offset new dialogs
	header = 33.0,

	title = T(1000016--[[Title--]]),
	RolloverTemplate = "Rollover",
}

function DisableDroneMaintenance_Window:AddElements(_,context)
	local g_Classes = g_Classes

	-- scale to UI
--~ 	self.dialog_width = self.dialog_width * ChoGGi.Temp.UIScale
--~ 	self.dialog_height = self.dialog_height * ChoGGi.Temp.UIScale
--~ 	self.header = self.header * ChoGGi.Temp.UIScale

	-- add container dialog for everything to fit in
	self.idDialog = g_Classes.DisableDroneMaintenance_Dialog:new({
		Background = dark_gray,
		BorderWidth = 2,
		BorderColor = light_gray,
	}, self)
	-- needed for :Wait()
	self.idDialog:Open()

	-- x,y,w,h (start off with all dialogs at 100,100, default size, and we move later)
	self.idDialog:SetBox(100, 100, self.dialog_width, self.dialog_height)

	self.idSizeControl = g_Classes.XSizeControl:new({
	}, self.idDialog)

	self.idTitleArea = g_Classes.DisableDroneMaintenance_DialogSection:new({
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

	self.idCloseX = DisableDroneMaintenance_CloseButton:new({
		OnPress = context.func or function()
			self:Close("cancel",false)
		end,
	}, self.idTitleArea)

	self.idCaption = g_Classes.XLabel:new({
		Id = "idCaption",
		TextFont = "Editor14Bold",
		Margins = box(4, -20, 4, 2),
		Translate = self.Translate,
		TextColor = white,
	}, self.idTitleArea)
	self.idCaption:SetText(self.title)
end

-- returns point(x,y)
function DisableDroneMaintenance_Window:GetPos(dialog)
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
function DisableDroneMaintenance_Window:SetPos(obj)
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

function DisableDroneMaintenance_Window:SetSize(size)
	local box = self.idDialog.box
	local x,y = box:minx(),box:miny()
	local w,h = size:x(),size:y()
	self.idDialog:SetBox(x,y,w,h)
end
function DisableDroneMaintenance_Window:SetWidth(w)
	self:SetSize(point(w,self.idDialog.box:sizey()))
end
function DisableDroneMaintenance_Window:SetHeight(h)
	self:SetSize(point(self.idDialog.box:sizex(),h))
end
function DisableDroneMaintenance_Window:GetSize()
	local b = self.idDialog.box
	return point(b:sizex(),b:sizey())
end

local GetMousePos = terminal.GetMousePos
local GetSafeAreaBox = GetSafeAreaBox
function DisableDroneMaintenance_Window:SetInitPos(parent)
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

DefineClass.DisableDroneMaintenance_SleekScroll = {
	__parents = {"XSleekScroll"},
	MinThumbSize = 30,
	AutoHide = true,
	Background = invis,
}

DefineClass.DisableDroneMaintenance_ScrollArea = {
	__parents = {"XScrollArea"},
	UniformColumnWidth = true,
	UniformRowHeight = true,
}

-- scrollable textbox
function DisableDroneMaintenance_Window:AddScrollText()
	local g_Classes = g_Classes

	self.idScrollSection = g_Classes.DisableDroneMaintenance_DialogSection:new({
		Id = "idScrollSection",
		BorderWidth = 1,
		Margins = box(0,0,0,0),
		BorderColor = light_gray,
	}, self.idDialog)

	self.idScrollArea = g_Classes.DisableDroneMaintenance_ScrollArea:new({
		Id = "idScrollArea",
		VScroll = "idScrollV",
		HScroll = "idScrollH",
		Margins = box(4,4,4,4),
		BorderWidth = 0,
	}, self.idScrollSection)

	self.idScrollV = g_Classes.DisableDroneMaintenance_SleekScroll:new({
		Id = "idScrollV",
		Target = "idScrollArea",
		Dock = "right",
	}, self.idScrollSection)

	self.idScrollH = g_Classes.DisableDroneMaintenance_SleekScroll:new({
		Id = "idScrollH",
		Target = "idScrollArea",
		Dock = "bottom",
		Horizontal = true,
	}, self.idScrollSection)

	self.idText = g_Classes.DisableDroneMaintenance_Text:new({
		Id = "idText",
		OnHyperLink = function(_, link, _, box, pos, button)
			self.onclick_handles[tonumber(link)](box, pos, button)
		end,
	}, self.idScrollArea)
end

function DisableDroneMaintenance_Window:AddScrollList()
	local g_Classes = g_Classes

	self.idScrollSection = g_Classes.DisableDroneMaintenance_DialogSection:new({
		Id = "idScrollSection",
		Margins = box(4,4,4,4),
	}, self.idDialog)

	self.idScrollArea = g_Classes.DisableDroneMaintenance_ScrollArea:new({
		Id = "idScrollArea",
		VScroll = "idScrollV",
		Margins = box(4,4,4,4),
	}, self.idScrollSection)

	self.idScrollV = g_Classes.DisableDroneMaintenance_SleekScroll:new({
		Id = "idScrollV",
		Target = "idScrollArea",
		Dock = "right",
	}, self.idScrollSection)

	self.idList = g_Classes.DisableDroneMaintenance_List:new({
		Id = "idList",
		VScroll = "idScrollV",
	}, self.idScrollArea)

end

function DisableDroneMaintenance_Window:AddScrollEdit()
	local g_Classes = g_Classes

	self.idScrollSection = g_Classes.DisableDroneMaintenance_DialogSection:new({
		Id = "idScrollSection",
	}, self.idDialog)

	self.idScrollV = g_Classes.DisableDroneMaintenance_SleekScroll:new({
		Id = "idScrollV",
		Target = "idEdit",
		Dock = "right",
	}, self.idScrollSection)

	self.idScrollH = g_Classes.DisableDroneMaintenance_SleekScroll:new({
		Id = "idScrollH",
		Target = "idEdit",
		Dock = "bottom",
		Horizontal = true,
	}, self.idScrollSection)

	self.idEdit = DisableDroneMaintenance_MultiLineEdit:new({
		Id = "idEdit",
		VScroll = "idScrollV",
		HScroll = "idScrollH",
		Margins = box(4,4,4,4),
		WordWrap = false,
	}, self.idScrollSection)
end

-- convenience function
function DisableDroneMaintenance_SleekScroll:SetHorizontal()
	self.MinHeight = 10
--~	 self.MaxHeight = 10
	self.MinWidth = 10
--~	 self.MaxWidth = 10
end

-- haven't figured on a decent place to put this, so good enough for now (AddedFunctions maybe?)
XShortcutsHost.SetPos = function(self,pt)
	self:SetBox(pt:x(),pt:y(),self.box:sizex(),self.box:sizey())
end
XShortcutsHost.GetPos = function(self)
	return DisableDroneMaintenance_Window.GetPos(self,"idMenuBar")
end
