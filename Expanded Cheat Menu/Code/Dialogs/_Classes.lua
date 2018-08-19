-- See LICENSE for terms

--~ function XWindow:CreateThread(name, func, ...)
--~   func = func or name
--~   self.real_time_threads = self.real_time_threads or {}
--~   DeleteThread(self.real_time_threads[name])
--~   self.real_time_threads[name] = CreateRealTimeThread(func, ...)
--~ end
--~ self:CreateThread("update", function(self)
--~   while true do
--~     RebuildInfopanel(ResolvePropObj(self.context), 999)
--~     Sleep(1000)
--~   end
--~ end, self)

--~ local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings

local box,point = box,point
local RGBA = RGBA

local white = -1
local black = black
local dark_gray = -13158858
local medium_gray = -10592674
local light_gray = -2368549
local rollover_blue = -14113793
local invis = 0
local invis_less = 268435456

local text = "Editor12Bold"
if ChoGGi.testing then
  text = "Editor14Bold"
end
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
--~   WordWrap = true,
}
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
}
--~ function ChoGGi_MultiLineEdit:InsertStrAtCaret(str)
--~   local pos = self:GetCursorCharIdx() + 1
--~   local line, char = self.cursor_line, self.cursor_char
--~   local text = self:GetText()
--~   self:SetText(Concat(text:sub(1,pos),str,text:sub(pos+1)))
--~   self:SetCursor(line,char+13)
--~ end

DefineClass.ChoGGi_Buttons = {
  __parents = {"XTextButton"},
  RolloverTitle = S[126095410863--[[Info--]]],
  RolloverTemplate = "Rollover",
  RolloverBackground = rollover_blue,
  RolloverTextColor = white,
  Margins = box(4,0,0,0),
}

DefineClass.ChoGGi_CloseButton = {
  __parents = {"ChoGGi_Buttons"},
  RolloverText = S[1011--[[Close--]]],
  RolloverAnchor = "right",
  Image = "UI/Common/mission_no.tga",
  Dock = "top",
  HAlign = "right",
  Margins = box(0, 1, 1, 0),
}

DefineClass.ChoGGi_Button = {
  __parents = {"ChoGGi_Buttons"},
  RolloverAnchor = "bottom",
  MinWidth = 60,
  Text = S[6878--[[OK--]]],
  Background = light_gray,
}
DefineClass.ChoGGi_ConsoleButton = {
  __parents = {"ChoGGi_Button"},
  Padding = box(5, 2, 5, 2),
  TextFont = "Editor16Bold",
  RolloverAnchor = "right",
  PressedBackground = dark_gray,
}

function ChoGGi_Button:Init()
  self.idLabel:SetDock("box")
end

DefineClass.ChoGGi_ButtonMenu = {
  __parents = {"ChoGGi_Button"},
  LayoutMethod = "HList",
  RolloverAnchor = "smart",
  TextFont = "Editor16Bold",
  TextColor = black,
}
DefineClass.ChoGGi_ComboButton = {
  __parents = {"XComboButton"},
  Background = light_gray,
  RolloverBackground = rollover_blue,
  RolloverTextColor = white,
  RolloverAnchor = "top",
  RolloverTitle = S[126095410863--[[Info--]]],
  RolloverTemplate = "Rollover",
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

function ChoGGi_CheckButton:Init()
--~   XCheckButton.Init(self)
  self.idIcon:SetBackground(light_gray)
end

DefineClass.ChoGGi_TextInput = {
  __parents = {"XEdit"},
  WordWrap = false,
  AllowTabs = false,
  RolloverTitle = S[126095410863--[[Info--]]],
  RolloverAnchor = "top",
  RolloverTemplate = "Rollover",
}
--~ function ChoGGi_TextInput:Init()
--~   self:SetText(self.display_text or "")
--~ end

DefineClass.ChoGGi_List = {
  __parents = {"XList"},
  RolloverTemplate = "Rollover",
}

DefineClass.ChoGGi_Dialog = {
  __parents = {"XDialog"},
  Translate = false,
  MinHeight = 50,
  MinWidth = 150,
  BackgroundColor = invis_less,
--~   HAlign = "left",
--~   VAlign = "top",
  Dock = "ignore",
  RolloverTemplate = "Rollover",
}

DefineClass.ChoGGi_DialogSection = {
  __parents = {"XWindow"},
  Margins = box(4,4,4,4),
  FoldWhenHidden = true,
  RolloverTemplate = "Rollover",
}

DefineClass.ChoGGi_Window = {
  __parents = {"XWindow"},
  dialog_width = 500,
  dialog_height = 500,
  -- above console
  ZOrder = 5,
  -- how far down to y-offset new dialogs
  header = 33,

  title = S[1000016--[[Title--]]],
  RolloverTemplate = "Rollover",
}

function ChoGGi_Window:AddElements(_,context)
  local g_Classes = g_Classes

  -- add container dialog for everything to fit in
  self.idDialog = g_Classes.ChoGGi_Dialog:new({
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

  self.idTitleArea = g_Classes.ChoGGi_DialogSection:new({
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

  self.idCloseX = ChoGGi_CloseButton:new({
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
  self.idCaption:SetText(ChoGGi.ComFuncs.CheckText(self.title,""))
end

-- returns point(x,y)
function ChoGGi_Window:GetPos(dialog)
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
function ChoGGi_Window:SetPos(obj)
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
function ChoGGi_Window:GetSize()
  local b = self.idDialog.box
  return point(b:sizex(),b:sizey())
end

local GetMousePos = terminal.GetMousePos
local GetSafeAreaBox = GetSafeAreaBox
function ChoGGi_Window:SetInitPos(parent)
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
    new_y = winh - h
  end

  self.idDialog:SetBox(new_x or x,new_y or y,w,h)
end

-- scrollable textbox
function ChoGGi_Window:AddScrollText()
  local g_Classes = g_Classes

  self.idScrollArea = g_Classes.ChoGGi_DialogSection:new({
    Id = "idScrollArea",
    BorderWidth = 1,
    Margins = box(0,0,0,0),
    BorderColor = light_gray,
  }, self.idDialog)

  self.idScrollV = g_Classes.ChoGGi_SleekScroll:new({
    Id = "idScrollV",
    Target = "idScrollBox",
    Dock = "right",
  }, self.idScrollArea)

  self.idScrollH = g_Classes.ChoGGi_SleekScroll:new({
    Id = "idScrollH",
    Target = "idScrollBox",
    Dock = "bottom",
    Horizontal = true,
  }, self.idScrollArea)

  self.idScrollBox = g_Classes.XScrollArea:new({
    Id = "idScrollBox",
    VScroll = "idScrollV",
    HScroll = "idScrollH",
    Margins = box(4,4,4,4),
    BorderWidth = 0,
  }, self.idScrollArea)

  self.idText = g_Classes.ChoGGi_Text:new({
    Id = "idText",
    OnHyperLink = function(_, link, _, box, pos, button)
      self.onclick_handles[tonumber(link)](box, pos, button)
    end,
  }, self.idScrollBox)
end

function ChoGGi_Window:AddScrollList()
  local g_Classes = g_Classes

  self.idScrollArea = g_Classes.ChoGGi_DialogSection:new({
    Id = "idScrollArea",
    Margins = box(4,4,4,4),
  }, self.idDialog)

  self.idScrollBox = g_Classes.XScrollArea:new({
    Id = "idScrollBox",
    VScroll = "idScrollV",
    Margins = box(4,4,4,4),
  }, self.idScrollArea)

  self.idScrollV = g_Classes.ChoGGi_SleekScroll:new({
    Id = "idScrollV",
    Target = "idScrollBox",
    Dock = "right",
  }, self.idScrollArea)

  self.idList = g_Classes.ChoGGi_List:new({
    Id = "idList",
    VScroll = "idScrollV",
  }, self.idScrollBox)

end

function ChoGGi_Window:AddScrollEdit()
  local g_Classes = g_Classes

  self.idScrollArea = g_Classes.ChoGGi_DialogSection:new({
    Id = "idScrollArea",
  }, self.idDialog)

  self.idScrollV = g_Classes.ChoGGi_SleekScroll:new({
    Id = "idScrollV",
    Target = "idEdit",
    Dock = "right",
  }, self.idScrollArea)

  self.idScrollH = g_Classes.ChoGGi_SleekScroll:new({
    Id = "idScrollH",
    Target = "idEdit",
    Dock = "bottom",
    Horizontal = true,
  }, self.idScrollArea)

  self.idEdit = ChoGGi_MultiLineEdit:new({
    Id = "idEdit",
    VScroll = "idScrollV",
    HScroll = "idScrollH",
    Margins = box(4,4,4,4),
  }, self.idScrollArea)
end

DefineClass.ChoGGi_SleekScroll = {
  __parents = {"XSleekScroll"},
  MinThumbSize = 30,
  AutoHide = true,
  Background = invis,
}

-- convenience function
function ChoGGi_SleekScroll:SetHorizontal()
  self.MinHeight = 10
--~   self.MaxHeight = 10
  self.MinWidth = 10
--~   self.MaxWidth = 10
end

-- haven't figured on a decent place to put this, so good enough for now (AddedFunctions maybe?)
XShortcutsHost.SetPos = function(self,pt)
  self:SetBox(pt:x(),pt:y(),self.box:sizex(),self.box:sizey())
end
XShortcutsHost.GetPos = function(self)
  return ChoGGi_Window.GetPos(self,"idMenuBar")
end
