-- See LICENSE for terms

local Concat = ChoGGi.ComFuncs.Concat
local S = ChoGGi.Strings

local RGB = RGB
local box = box
local point = point

local white = white
local black = black
local dark_gray = -13158858
local medium_gray = -10592674
local light_gray = -2368549
local rollover_blue = RGB(24, 123, 197)

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
  WordWrap = true,
}
DefineClass.ChoGGi_MultiLineEdit = {
  __parents = {"XMultiLineEdit"},
  TextFont = "Editor16",
  --default
  Background = dark_gray,
  TextColor = white,
  --focused
  FocusedBackground = dark_gray,
  RolloverTextColor = white,
  --selected
  SelectionBackground = light_gray,
  SelectionColor = black,

  MaxLen = -1,
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
  Margins = box(0, 4, 2, 0),
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
}

DefineClass.ChoGGi_CheckButton = {
  __parents = {"XCheckButton"},
  RolloverTitle = S[126095410863--[[Info--]]],
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
--~   Multiline = false,
--~   WordWrap = false,
--~   AllowTabs = false,
  RolloverTitle = S[126095410863--[[Info--]]],
--~   -- text displayed till mouse/kb focus
--~   display_text = false,
  RolloverAnchor = "top",
}
--~ function ChoGGi_TextInput:Init()
--~   self:SetText(self.display_text or "")
--~ end

DefineClass.ChoGGi_List = {
  __parents = {"XList"},
}

DefineClass.ChoGGi_Dialog = {
  __parents = {"XDialog"},
  Translate = false,
  MinHeight = 50,
  MinWidth = 150,
  BackgroundColor = RGBA(0, 0, 0, 16),
--~   HAlign = "left",
--~   VAlign = "top",
  Dock = "ignore",
}

DefineClass.ChoGGi_DialogSection = {
  __parents = {"XWindow"},
  Margins = box(4,4,4,4),
  FoldWhenHidden = true,
}

DefineClass.ChoGGi_Window = {
  __parents = {"XWindow"},
  dialog_width = 500,
  dialog_height = 500,
  -- above console
  ZOrder = 5,
}

function ChoGGi_Window:AddElements(parent,context)
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
  self.idCaption:SetText(ChoGGi.ComFuncs.CheckText(self.title,S[1000016--[[Title--]]]))
end

-- returns x,y
function ChoGGi_Window:GetPos()
  local b = self.idDialog.box
  return point(b:minx(),b:miny())
end

-- takes either a point, or box to set pos
function ChoGGi_Window:SetPos(obj)
--~ box(left, top, right, bottom) :minx() :miny() :sizex() :sizey()
  local x,y,w,h
  if IsPoint(obj) then
    local box = self.idDialog.box
    x = obj:x()
    y = obj:y()
    w = box:sizex()
    h = box:sizey()
  else
    local box = obj.idDialog.box
    x = box:minx()
    y = box:miny() + 25
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
function ChoGGi_Window:SetInitPos(parent)
  -- set dialog pos
  if parent then
    self:SetPos(parent)
  else
    self:SetPos(GetMousePos())
  end
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

function ChoGGi_Window:AddScrollEdit(context)
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
    WordWrap = context.wrap or false,
    VScroll = "idScrollV",
    HScroll = "idScrollH",
    Margins = box(4,4,4,4),
  }, self.idScrollArea)
end

DefineClass.ChoGGi_SleekScroll = {
  __parents = {"XSleekScroll"},
  MinThumbSize = 30,
  AutoHide = true,
  Background = RGBA(0,0,0,0),
}

-- convenience function
function ChoGGi_SleekScroll:SetHorizontal()
  self.MinHeight = 10
  self.MaxHeight = 10
  self.MinWidth = 10
  self.MaxWidth = 10
end
