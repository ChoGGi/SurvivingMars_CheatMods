-- See LICENSE for terms

--~ box(left, top, right, bottom) :minx() :miny() :sizex() :sizey()

local Trans = ChoGGi.ComFuncs.Translate
local CheckText = ChoGGi.ComFuncs.CheckText
--~ local RetName = ChoGGi.ComFuncs.RetName
local GetParentOfKind = ChoGGi.ComFuncs.GetParentOfKind
local S = ChoGGi.Strings

local box,point = box,point
local IsValid = IsValid
local PropObjGetProperty = PropObjGetProperty
local MeasureImage = UIL.MeasureImage

-- see also TextStyles.lua
local white = -1
local black = -16777216
local dark_blue = -12235133
local darker_blue = -16767678
local dark_gray = -13158858
local darker_gray = -13684945
--~ local less_dark_gray = -12500671
local medium_gray = -10592674
local light_gray = -2368549
local rollover_blue = -14113793
local invis = 0
--~ local invis_less = 268435456

local text_style1 = "ChoGGi_Text12"
local text_style2 = "ChoGGi_TextList12"
if ChoGGi.testing then
	text_style1 = "ChoGGi_Text14"
	text_style2 = "ChoGGi_TextList14"
end
DefineClass.ChoGGi_Text = {
	__parents = {"XText"},
	TextStyle = text_style1,
	-- default
	Background = dark_gray,
	-- focused
	FocusedBackground = dark_gray,
	-- selected
	SelectionBackground = light_gray,
	SelectionColor = black,

	RolloverTemplate = "Rollover",
	RolloverTitle = Trans(126095410863--[[Info--]]),
}
--~ function ChoGGi_Text:OnHyperLinkRollover()
--~ print("Rollover")
--~ end
--~ function XText:OnHyperLinkRollover(hyperlink, hyperlink_box, pos)
--~ end

DefineClass.ChoGGi_MultiLineEdit = {
	__parents = {"XMultiLineEdit"},
	TextStyle = "ChoGGi_MultiLineEdit",
	-- default
	Background = dark_gray,
	-- focused
	FocusedBackground = darker_gray,
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
	TextStyle = "ChoGGi_Label",
	Translate = false,
	VAlign = "center",
}
function ChoGGi_Label:SetTitle(win,title)
	if win.prefix then
		win.idCaption:SetText(
			CheckText(win.prefix,"") .. ": " .. CheckText(title or win.title,self.name)
		)
	else
		win.idCaption:SetText(
			CheckText(title or win.title,self.name)
		)
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
	RolloverTemplate = "Rollover",
}
--~ 		ScaleModifier = point(2500, 2500),

DefineClass.ChoGGi_ImageRows = {
	__parents = {"XImage"},
	Rows = 2,
	VAlign = "center",
	HandleKeyboard = false,
	ImageScale = point(250, 250),
--~ 	Margins = box(4, 0, 0, 0),
	RolloverTemplate = "Rollover",
}
DefineClass.ChoGGi_MoveControl = {
	__parents = {"XMoveControl"},
	Dock = "top",
	Background = medium_gray,
	FocusedBackground = dark_blue,
	FocusedColor = light_gray,
	RolloverTitle = Trans(126095410863--[[Info--]]),
	RolloverTemplate = "Rollover",
}
local IsShiftPressed = ChoGGi.ComFuncs.IsShiftPressed
function ChoGGi_MoveControl:OnKbdKeyDown(vk,...)
	if vk == const.vkEsc and IsShiftPressed() then
		self.dialog.idCloseX:Press()
		return "break"
	end
	return XMoveControl.OnKbdKeyDown(self,vk,...)
end

function ChoGGi_MoveControl:ToggleRollup(win,bool)
	for i = 1, #win.idDialog do
		local section = win.idDialog[i]
		if section.class ~= "ChoGGi_MoveControl" then
			section:SetVisible(bool)
		end
	end

	if bool and win.idList and win.custom_type == 1 then
		win.idButtonContainer:SetVisible(false)
	end
end

function ChoGGi_MoveControl:OnMouseButtonDoubleClick(pt,button,...)
	-- window object
	local win = GetParentOfKind(self, "ChoGGi_Window")
	if win.idDialog then
		if win.dialog_rolled_up then
			-- already rolled up so unhide sections and get saved size
			self:ToggleRollup(win,true)
			win:SetHeight(win.dialog_rolled_up)
			win.dialog_rolled_up = false
		else
			-- save size and hide sections
			self:ToggleRollup(win,false)
			win.dialog_rolled_up = win:GetHeight()
			win:SetHeight(win.header_scaled)
		end
	end
	return XMoveControl.OnMouseButtonDoubleClick(self,pt,button,...)
end

DefineClass.ChoGGi_Buttons = {
	__parents = {"XTextButton"},
	TextStyle = "ChoGGi_Buttons",
	RolloverTitle = Trans(126095410863--[[Info--]]),
	RolloverHint = S[302535920000083--[[<left_click> Activate--]]],
	RolloverTemplate = "Rollover",
	RolloverBackground = rollover_blue,
	Margins = box(4,4,4,4),
	PressedBackground = medium_gray,
	PressedTextColor = white,
	RolloverZoom = 1100,
}

DefineClass.ChoGGi_ToolbarButton = {
	__parents = {"ChoGGi_Buttons"},
	RolloverZoom = 1600,
	ImageScale = point(1100,1100),
	MinWidth = 0,
	Text = "",
	Margins = box(1, 0, 0, 0),
	FoldWhenHidden = true,
	RolloverBackground = white,
	PressedBackground = light_gray,
}
DefineClass.ChoGGi_Button = {
	__parents = {"ChoGGi_Buttons"},
--~ 	MinWidth = 60,
	Text = Trans(6878--[[OK--]]),
	Background = light_gray,
	bg_green = -8192126,
	bg_red = -41121,
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
	RolloverTitle = Trans(1011--[[Close--]]),
	RolloverText = S[302535920000074--[[Cancel without changing anything.--]]],
}

DefineClass.ChoGGi_ConsoleButton = {
	__parents = {"ChoGGi_Button"},
	TextStyle = "ChoGGi_ConsoleButton",
	Padding = box(5, 2, 5, 2),
	BorderWidth = 1,
	BorderColor = black,
	RolloverBorderColor = black,
	Margins = box(4,0,0,0),
}

DefineClass.ChoGGi_ButtonMenu = {
	__parents = {"ChoGGi_Button"},
	TextStyle = "ChoGGi_ButtonMenu",
	LayoutMethod = "HList",
	Margins = box(0,0,0,0),
}
DefineClass.ChoGGi_ComboButton = {
	__parents = {"XComboButton"},
	TextStyle = "ChoGGi_ComboButton",
	Background = light_gray,
	RolloverBackground = rollover_blue,
	RolloverTitle = Trans(126095410863--[[Info--]]),
	RolloverHint = S[302535920000083--[[<left_click> Activate--]]],
	RolloverTemplate = "Rollover",
	PressedBackground = medium_gray,
	PressedTextColor = white,
	Margins = box(4,4,0,4),
	RolloverZoom = 1100,
	BorderWidth = 1,
	BorderColor = black,
	RolloverBorderColor = black,
}
--~ function ChoGGi_ComboButton:Init()
--~ 	self:SetIcon("CommonAssets/UI/arrowright-40.tga")
--~ end
--~ function ChoGGi_ComboButton:OnMouseButtonDown()
--~ 	self:SetIcon("CommonAssets/UI/arrowdown-40.tga")
--~ 	DeleteThread(self.popup_opened)
--~ 	self.popup_opened = CreateRealTimeThread(function()
--~ 		while self.popup_opened do
--~ 			Sleep
--~ 		end
--~ 	end)
--~ end
--~ function ChoGGi_ComboButton:OnMouseButtonUp()
--~ 	self:SetIcon("CommonAssets/UI/arrowright-40.tga")
--~ end

DefineClass.ChoGGi_CheckButton = {
	__parents = {"XCheckButton"},
	TextStyle = "ChoGGi_CheckButton",
	RolloverTitle = Trans(126095410863--[[Info--]]),
	RolloverHint = S[302535920000083--[[<left_click> Activate--]]],
	RolloverTemplate = "Rollover",
	MinWidth = 60,
	Text = Trans(6878--[[OK--]]),
	RolloverZoom = 1100,
	FoldWhenHidden = true,
}
function ChoGGi_CheckButton:Init()
	self.idIcon:SetBackground(light_gray)
end

DefineClass.ChoGGi_PopupList = {
	__parents = {"XPopupList"},
	-- -1000 is for XRollovers which get max_int
	ZOrder = max_int - 1000,
	-- what? i like 3d
	BorderWidth = 2,
--~ 	LayoutMethod = "VList",
}
function ChoGGi_PopupList:Close(...)
	if self.items and self.items.clear_objs then
		ChoGGi.ComFuncs.ClearShowObj(true)
	end
	XPopupList.Close(self,...)
end

DefineClass.ChoGGi_CheckButtonMenu = {
	__parents = {"ChoGGi_CheckButton"},
	TextStyle = "ChoGGi_CheckButtonMenu",
	Background = light_gray,
	PressedBackground = medium_gray,
	TextHAlign = "left",
	RolloverBackground = rollover_blue,
	Padding = box(4,0,0,0),
}

DefineClass.ChoGGi_TextInput = {
	__parents = {"XEdit"},
	WordWrap = false,
	AllowTabs = false,
	RolloverTitle = Trans(126095410863--[[Info--]]),
	RolloverTemplate = "Rollover",
	Background = light_gray,
--~ 	MouseCursor = ChoGGi.library_path .. "UI/text_input.png",
}

DefineClass.ChoGGi_ExternalTextEditorPlugin = {
	__parents = {"XExternalTextEditorPlugin"},
}

function ChoGGi_ExternalTextEditorPlugin:OpenEditor(edit)
	local g = ChoGGi.Temp._G
  g_ExternalTextEditorActiveCtrl = edit
	edit.external_file = edit.external_path .. "/tempedit.lua"

  g.AsyncCreatePath(edit.external_path)

  g.AsyncStringToFile(edit.external_file, edit:GetText())
  local cmd = edit.external_cmd:format(ConvertToOSPath(edit.external_file))

	local exec,result = g.os.execute(cmd)
	if not exec then
		print("ExternalTextEditorPlugin:",result)
	end
end
function ChoGGi_ExternalTextEditorPlugin:OnTextChanged(edit)
  if g_ExternalTextEditorActiveCtrl == edit then
    ChoGGi.Temp._G.AsyncStringToFile(edit.external_file, edit:GetText())
  end
end
function ChoGGi_ExternalTextEditorPlugin.ApplyEdit(file, change, edit)
  if g_ExternalTextEditorActiveCtrl == edit and change == "Modified" then
    local err, content = ChoGGi.Temp._G.AsyncFileToString(file or edit.external_file)
    if not err and edit then
      edit:SetText(content)
    end
	end
end
DefineClass.ChoGGi_CodeEditorPlugin = {
	__parents = {"XCodeEditorPlugin"},
  SelectionColor = -11364918,
  KeywordColor = -7421793,
}

DefineClass.ChoGGi_List = {
	__parents = {"XList"},
	TextStyle = "ChoGGi_List",
	RolloverTemplate = "Rollover",
--~ 	LayoutMethod = "VWrap",
	Background = dark_gray,
	FocusedBackground = darker_gray,
	loaded = false,
}
function ChoGGi_List:CreateTextItem(text, props, context)
	local g_Classes = g_Classes
	props = props or {}
	local item = g_Classes.ChoGGi_ListItem:new({
		selectable = props.selectable,
		MinWidth = GetParentOfKind(self, "ChoGGi_Window"):GetWidth(),
	}, self)

	props.selectable = nil
	local text_control = g_Classes.ChoGGi_TextList:new(props, item, context)
	item.idText = text_control
	text_control:SetText(text)
	return item
end
DefineClass.ChoGGi_TextList = {
	__parents = {"XText"},
	TextStyle = text_style2,
	RolloverTemplate = "Rollover",
	RolloverTitle = Trans(126095410863--[[Info--]]),
	VAlign = "center",
}

DefineClass.ChoGGi_ListItem = {
	__parents = {"XListItem"},
	RolloverZoom = 1100,
--~ 	Background = dark_gray,
	SelectionBackground = darker_blue,
--~ 	FocusedBorderColor = rollover_blue,
}

DefineClass.ChoGGi_Dialog = {
	__parents = {"XDialog"},
	HandleMouse = true,
	Translate = false,
	MinHeight = 50,
	MinWidth = 150,
	Dock = "ignore",
	RolloverTemplate = "Rollover",
	RolloverTitle = Trans(126095410863--[[Info--]]),
	Background = dark_gray,
	BorderWidth = 2,
	BorderColor = light_gray,
	Clip = "self",
}

DefineClass.ChoGGi_DialogSection = {
	__parents = {"XWindow"},
	HandleMouse = true,
	FoldWhenHidden = true,
	RolloverTemplate = "Rollover",
	RolloverTitle = Trans(126095410863--[[Info--]]),
	Clip = "self",
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
	self.MinWidth = 10
end

DefineClass.ChoGGi_Window = {
	__parents = {"XWindow"},
	dialog_width = 500.0,
	dialog_height = 500.0,
	dialog_width_scaled = false,
	dialog_height_scaled = false,
	-- above console
	ZOrder = 5,
	-- how far down to y-offset new dialogs
	header = 34.0,
	header_scaled = false,
	-- prefix some string to the title
	prefix = false,

	RolloverTemplate = "Rollover",

	action_close = false,
	action_host = false,
}

-- store opened dialogs
if not PropObjGetProperty(_G,"g_ChoGGiDlgs") then
	g_ChoGGiDlgs = objlist:new()
end

-- parent,context
function ChoGGi_Window:AddElements()
	local g_Classes = g_Classes
	local ChoGGi = ChoGGi

	g_ChoGGiDlgs[self] = self.class

	-- scale to UI (See OnMsgs.lua for UIScale)
	local UIScale = ChoGGi.Temp.UIScale
	self.dialog_width_scaled = self.dialog_width * UIScale
	self.dialog_height_scaled = self.dialog_height * UIScale
	self.header_scaled = self.header * UIScale

	-- add container dialog for everything to fit in
	self.idDialog = g_Classes.ChoGGi_Dialog:new({
		-- keep stuff from spilling outside the dialog
		Clip = "self",
	}, self)

	-- x,y,w,h (start off with all dialogs at 100,100, default size, and we move later)
	self.idDialog:SetBox(100, 100, self.dialog_width_scaled, self.dialog_height_scaled)

	self.idSizeControl = g_Classes.XSizeControl:new({
		Id = "idSizeControl",
	}, self.idDialog)

	self.idMoveControl = g_Classes.ChoGGi_MoveControl:new({
		Id = "idMoveControl",
		dialog = self,
			-- need a bit of space so the X fits in the header
		Padding = box(0,1,0,1),
		-- stop title from overflowing
	}, self.idDialog)

	self.idTitleLeftSection = g_Classes.ChoGGi_DialogSection:new({
		Id = "idTitleLeftSection",
		HAlign = "left",
		Margins = box(0,0,32,0),
	}, self.idMoveControl)

	self.idTitleRightSection = g_Classes.ChoGGi_DialogSection:new({
		Id = "idTitleRightSection",
		HAlign = "right",
	}, self.idMoveControl)

	local close = self.close_func or empty_func
	self.idCloseX = g_Classes.ChoGGi_CloseButton:new({
		Id = "idCloseX",
		OnPress = function(...)
			-- kill off exter editor if active
			local ext = g_ExternalTextEditorActiveCtrl
			if ext and ext.delete then
				ext:delete()
				g_ExternalTextEditorActiveCtrl = false
			end
			close(...)
			self:Close("cancel",false)
		end,
	}, self.idTitleRightSection)

	-- throws error if we try to get display_icon from _G
	local image = self.title_image or (type(self.obj) == "table" and self.name ~= "_G"
		and (PropObjGetProperty(self.obj,"display_icon") and self.obj.display_icon ~= "" and self.obj.display_icon
		or PropObjGetProperty(self.obj,"pin_icon") and self.obj.pin_icon ~= "" and self.obj.pin_icon))

	-- as long as x isn't 0 then it's probably an image
	local is_image = type(image) == "string" and MeasureImage(image) ~= 0

	-- DroneResourceUnits.ANYTHING will return 1000
	if is_image then
		self.idCaptionImage = g_Classes.ChoGGi_Image:new({
			Id = "idCaptionImage",
			Dock = "left",
			RolloverTitle = S[302535920000093--[[Go to Obj--]]],
			RolloverText = S[302535920000094--[[View/select object on map.--]]],
			RolloverHint = S[302535920000083--[[<left_click> Activate--]]],
			OnMouseButtonDown = self.idCaptionOnMouseButtonDown,
			HandleMouse = true,
		}, self.idTitleLeftSection)

		self.idCaptionImage:SetImage(image)
		-- remove column and such so it displays fine
		if self.title_image_single then
			self.idCaptionImage:SetColumns(1)
			self.idCaptionImage:SetImageScale(point(1000,1000))
			self.idCaptionImage:SetRolloverText("")
		end
	end

	-- title
	self.idCaption = g_Classes.ChoGGi_Label:new({
		Id = "idCaption",
		Padding = box(4,0,0,0),
	}, self.idTitleLeftSection)
	self.idCaption:SetTitle(self)

	-- needed for :Wait()
	self.idDialog:Open()
	-- it's so blue
	self.idMoveControl:SetFocus()
end

function ChoGGi_Window:Done(result,...)
	-- remove from dialog list
	g_ChoGGiDlgs[self] = nil

	XWindow.Done(self,result,...)
end

function ChoGGi_Window:idCaptionOnMouseButtonDown(pt,button,...)
	ChoGGi_Image.OnMouseButtonDown(pt,button,...)
	local dlg = GetParentOfKind(self, "ChoGGi_Window")
	if IsValid(dlg.obj) then
		ViewAndSelectObject(dlg.obj)
	end
end

-- returns point(x,y)
function ChoGGi_Window:GetPos(dialog)
	return (self[dialog or "idDialog"].box):min()
end

local GetMousePos = terminal.GetMousePos
local GetSafeAreaBox = GetSafeAreaBox
-- get size of box and offset header
function ChoGGi_Window:BoxSize(obj)
--~ box(left, top, right, bottom) :minx() :miny() :sizex() :sizey()
	local obj_dlg = obj.idDialog or obj.idContainer
	if not obj_dlg then
		return
	end

	local x,y,w,h
	local box = obj_dlg.box
	x = box:minx()
	y = box:miny() + self.header_scaled
	if self.class == "Examine" then
		-- it's a copy of examine/find value wanting a new window offset, so we want the size of it
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
function ChoGGi_Window:SetPos(obj,dialog)
	local dlg = self[dialog or "idDialog"]
	local x,y,w,h = self.BoxSize and self:BoxSize(obj) or ChoGGi_Window.BoxSize(self,obj)

	if IsPoint(obj) then
		local box = dlg.box
		x = obj:x()
		y = obj:y()
		w = box:sizex()
		h = box:sizey()
	end

	if not x then
		local pt = GetMousePos()
		local box = dlg.box
		x = pt:x()
		y = pt:y()
		w = box:sizex()
		h = box:sizey()
	end

	dlg:SetBox(x,y,w,h)
end

function ChoGGi_Window:SetSize(size,dialog)
	local dlg = self[dialog or "idDialog"]
	local box = dlg.box
	local x,y = box:minx(),box:miny()
	local w,h = size:x(),size:y()
	dlg:SetBox(x,y,w,h)
end
function ChoGGi_Window:ResetSize(dialog)
	self:SetSize(point(self.dialog_width_scaled, self.dialog_height_scaled),dialog or "idDialog")
end
function ChoGGi_Window:SetWidth(w, dialog)
	self:SetSize(point(w, self[dialog or "idDialog"].box:sizey()))
end
function ChoGGi_Window:SetHeight(h,dialog)
	self:SetSize(point(self[dialog or "idDialog"].box:sizex(),h))
end
function ChoGGi_Window:GetSize(dialog)
	return (self[dialog or "idDialog"].box):size()
end
function ChoGGi_Window:GetHeight(dialog)
	return (self[dialog or "idDialog"].box):sizey()
end
function ChoGGi_Window:GetWidth(dialog)
	return (self[dialog or "idDialog"].box):sizex()
end

local function UpdateListWidth(self)
	WaitMsg("OnRender")
	if self.idList[1] then
		local width = self.idList[1].box:sizex()
		if width > 0 then
			self:SetWidth(width + 35)
		end
	end
end
function ChoGGi_Window:PostInit(parent,pt)
	local x,y,w,h

	-- some funcs opened in examine have more than one return value
	if type(parent) ~= "table" then
		parent = nil
	end

	-- if we're opened from another dialog then offset it, else open at mouse cursor
	if parent then
		x,y,w,h = self:BoxSize(parent)
	end
	-- if BoxSize failed or there isn't a parent we don't change the size, just re-pos
	if not parent or not x then
		local box = self.idDialog.box
		w = box:sizex()
		h = box:sizey()
	end

	if pt and IsPoint(pt) then
		x = pt:x()
		y = pt:y()
	elseif not parent then
		pt = GetMousePos()
		x = pt:x()
		y = pt:y()
	end

	-- just in case
	x = x or 0
	y = y or 0
	w = w or 100
	h = h or 100

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
			new_y = winh - h + self.header_scaled
			h = h - self.header_scaled
		else
			new_y = winh - h
		end
	end

	self.idDialog:SetBox(new_x or x,new_y or y,w,h)

	local is_list = self.idList and not self.idColourContainer

	-- resize width of dialog to match width of first list item
	if is_list then
		CreateRealTimeThread(UpdateListWidth,self)
	end

	-- add some tooltipping
	local move = self.idMoveControl
	if move then
		local ok = ""
		-- 1 hides the ok/cancel buttons, and it just looks weird for the colour Modifier
		if is_list and self.custom_type ~= 1 then
			ok = S[302535920000080--[["Press OK to apply and close dialog (Arrow keys and Enter/Esc can also be used, and probably double left-clicking <left_click>)."--]]] .. "\n\n"
		end
		local str = S[302535920001518--[[Double-click <left_click> title to rollup into the title bar.--]]]
		if move.RolloverText == "" then
			move.RolloverText = ok .. str
		else
			move.RolloverText = ok .. self.idMoveControl:GetRolloverText() .. "\n\n" .. str
		end
	end

end
-- needed till we update minimap and view colony map (since they both use the func name)
ChoGGi_Window.SetInitPos = ChoGGi_Window.PostInit

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
	}, self.idScrollArea)
end

function ChoGGi_Window:AddScrollList()
	local g_Classes = g_Classes

	self.idScrollSection = g_Classes.ChoGGi_DialogSection:new({
		Id = "idScrollSection",
		Margins = box(4,4,4,4),
	}, self.idDialog)

	self.idList = g_Classes.ChoGGi_List:new({
		Id = "idList",
		VScroll = "idScrollV",
		HScroll = "idScrollH",
	}, self.idScrollSection)

	self.idScrollV = g_Classes.ChoGGi_SleekScroll:new({
		Id = "idScrollV",
		Target = "idList",
		Dock = "right",
	}, self.idScrollSection)

	self.idScrollH = g_Classes.ChoGGi_SleekScroll:new({
		Id = "idScrollH",
		Target = "idList",
		Dock = "bottom",
		Horizontal = true,
	}, self.idScrollSection)
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

	self.idEdit = g_Classes.ChoGGi_MultiLineEdit:new({
		Id = "idEdit",
		VScroll = "idScrollV",
		HScroll = "idScrollH",
		WordWrap = ChoGGi.UserSettings.WordWrap or false,
	}, self.idScrollSection)
end

-- not sure why this isn't added?
if XTextEditor.RemovePlugin then
	printC("XTextEditor:RemovePlugin() is finally added, replace mine")
else
	function XTextEditor:RemovePlugin(plugin)
		local idx = table.find(self.plugins,"class",plugin)
		if idx then
			local plugin = self.plugins[idx]
			plugin:delete()
			table.remove(self.plugins,idx)
		end
	end
end
